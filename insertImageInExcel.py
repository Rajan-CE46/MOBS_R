
import os
from openpyxl import load_workbook
from openpyxl.drawing.image import Image

xlfile_name = "currentResWithError.xlsx"
png_file_name = "currentPareto.png"
# Create a new workbook
wb = load_workbook(xlfile_name)

# Select the active worksheet
ws = wb.active

# Load the PNG image
img = Image(png_file_name)

# Set the width and height of the image to 7 cells
img.width = 850
img.height = 550

# Add image to worksheet at cell N1
ws.add_image(img, 'N1')

# Save the workbook with the same filename
wb.save(xlfile_name)
