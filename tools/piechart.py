import base64
from io import BytesIO
from PIL import Image
import matplotlib
#matplotlib.use('Agg')
import matplotlib.pyplot as plt

values = [1, 2, 3, 4, 5, 6]
colors = ['#d9a300', '#00b200', '#2693ff', '#aaaaaa', '#ff4000', '#c926ff']

p, tx,  autotexts = plt.pie(values, colors=colors, autopct="", startangle=90, counterclock=False, radius=0.5)

for i, a in enumerate(autotexts):
    a.set_text('{}'.format(values[i]))
#plt.pie(values, colors=colors)
plt.axis('equal')

plt.show()
