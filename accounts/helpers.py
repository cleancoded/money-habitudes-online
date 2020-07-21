from django.core.files.base import ContentFile
from resizeimage import resizeimage
from io import BytesIO
from PIL import Image

def format_image(image, width, height):
    pil_image_obj = Image.open(image)
    new_image = resizeimage.resize_contain(pil_image_obj, [width, height])

    new_image_io = BytesIO()
    new_image.save(new_image_io, format='PNG')

    return ContentFile(new_image_io.getvalue())
