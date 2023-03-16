#!/usr/bin/env python3
# Author: Theodoros Pavlidis
# Renames the mp3's of a given folder according to their ID3 tags.

import os
from tinytag import TinyTag

def rename_files(folder_path):
    error_count = 0
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.endswith('.mp3'):
                filepath = os.path.join(root, file)
                try:
                    tag = TinyTag.get(filepath)
                    artist = tag.artist.replace('/', '_')
                    title = tag.title.replace('/', '_')
                    track_number = str(tag.track)
                    new_filename = f"{artist} - {track_number} {title}.mp3"
                    new_filename = new_filename.replace(':', '_')
                    new_filename = new_filename.replace('?', '_')
                    new_filename = new_filename.replace('\\', '_')
                    new_filepath = os.path.join(root, new_filename)
                    os.rename(filepath, new_filepath)
                    print(f"Renamed {filepath} to {new_filepath}")
                except:
                    print(f"Error renaming {filepath}")
                    error_count += 1
    print(f"Finished renaming files with {error_count} errors.")

rename_files('/mnt/Data/Music/Fix')
