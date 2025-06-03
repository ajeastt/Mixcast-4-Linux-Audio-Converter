#!/bin/bash

# Prompt for input file
read -p "Enter the path to the audio file: " input_file

# Check existence
if [[ ! -f "$input_file" ]]; then
    echo "❌ File not found!"
    exit 1
fi

# Extract base name
base_name=$(basename "$input_file")
name_no_ext="${base_name%.*}"
ext="${input_file##*.}"

# Detect sample rate
sample_rate=$(ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate \
  -of default=noprint_wrappers=1:nokey=1 "$input_file")

# Convert to 48kHz WAV if needed
if [[ "$ext" != "wav" || "$sample_rate" != "48000" ]]; then
    echo "⚠️ Converting to 48kHz WAV..."
    output_name="${name_no_ext}.wav"
    ffmpeg -y -i "$input_file" -ar 48000 "$output_name"
else
    echo "✅ File is already 48kHz WAV. Using as-is."
    output_name="$base_name"
fi

# Wait for Mixcast SD card
mount_path="/run/media/adam/Mixcast4/SOUNDPAD"
ppl_file="$mount_path/mixcast.ppl"

echo "🔍 Looking for Mixcast SD card..."
while [[ ! -f "$ppl_file" ]]; do
    echo "⏳ Waiting for $ppl_file..."
    sleep 3
done
echo "✅ SD card detected!"

# Determine next outnumber (A0XX)
last_num=$(grep -oP "<outnumber>A0\K[0-9]{2}" "$ppl_file" | tail -n 1)
if [[ -z "$last_num" ]]; then
    next_num=1
else
    next_num=$((10#$last_num + 1))
fi
next_code=$(printf "A%03d" "$next_num")

# Calculate bank/comment
bank=$(( (next_num - 1) / 8 + 1 ))
pos=$(( (next_num - 1) % 8 + 1 ))
comment="Bank${bank}_${pos}"

# Prepare XML block
item_entry=$(cat <<EOF
		<item>
			<outnumber>$next_code</outnumber>
			<fname>$output_name</fname>
			<sname></sname>
			<comment>$comment</comment>
			<_06color>color_yellow</_06color>
			<_06playmethod>method_latch</_06playmethod>
			<_06advanced></_06advanced>
			<_06volume>0.0</_06volume>
		</item>
EOF
)

# Insert the XML block before </body> using awk
tmp_file=$(mktemp)

awk -v block="$item_entry" '
    /<\/body>/ {
        print block
    }
    { print }
' "$ppl_file" > "$tmp_file" && mv "$tmp_file" "$ppl_file"

# Move file to SOUNDPAD directory
if [[ -f "$output_name" ]]; then
    cp "$output_name" "$mount_path/"
else
    cp "$input_file" "$mount_path/"
fi

echo "✅ Done! Added '$output_name' as $next_code ($comment) to Mixcast."
