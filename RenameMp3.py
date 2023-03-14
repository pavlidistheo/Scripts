import os
from tinytag import TinyTag

def rename_files(folder_path):
    for root, dirs, files in os.walk(folder_path):
        for filename in files:
            if filename.endswith('.mp3'):
                filepath = os.path.join(root, filename)
                tag = TinyTag.get(filepath)
                if tag.title is not None:
                    artist = tag.artist if tag.artist is not None else "Unknown Artist"
                    track_number = str(tag.track)
                    title = tag.title.replace("/", "_")
                    new_filename = f"{artist} - {track_number} {title}.mp3"
                    new_filepath = os.path.join(root, new_filename)
                    os.rename(filepath, new_filepath)
                    print(f"Renamed {filepath} to {new_filepath}")
                else:
                    print(f"Error: No title tag found for {filepath}")

if __name__ == '__main__':
    folder_path = '/mnt/Data/Music/Foreign'
    rename_files(folder_path)
