import os

def count_ytd_files(root_dir):
    """
    Counts the number of files with .ytd extension in each subfolder.
    
    Args:
        root_dir (str): The root directory to start searching from.
    
    Returns:
        dict: A dictionary with subfolder paths as keys and count of .ytd files as values.
    """
    ytd_counts = {}
    total_count = 0
    
    # Walk through all directories and subdirectories
    for dirpath, dirnames, filenames in os.walk(root_dir):
        # Count .ytd files in current directory
        ytd_files = [f for f in filenames if f.lower().endswith('.ytd')]
        count = len(ytd_files)
        
        # Only add to results if .ytd files were found
        if count > 0:
            ytd_counts[dirpath] = count
            total_count += count
    
    return ytd_counts, total_count

def main():
    # Get the starting directory from user or use current directory
    start_dir = input("Enter the directory path to search (press Enter for current directory): ")
    if not start_dir:
        start_dir = os.getcwd()
    
    # Make sure the directory exists
    if not os.path.isdir(start_dir):
        print(f"Error: '{start_dir}' is not a valid directory")
        return
    
    print(f"\nSearching for .ytd files in '{start_dir}' and its subfolders...\n")
    
    # Count the .ytd files
    results, total_files = count_ytd_files(start_dir)
    
    # Display results
    if not results:
        print("No .ytd files found.")
    else:
        print(f"Found {total_files} .ytd files in {len(results)} folders:")
        print("-" * 80)
        for folder, count in sorted(results.items()):
            print(f"{folder}: {count} file(s)")
        print("-" * 80)
        print(f"Total: {total_files} .ytd file(s)")

if __name__ == "__main__":
    main()