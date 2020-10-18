#!/usr/bin/python2.7

import turtle

#random function, it uses /dev/urandom because other imports are forbidden
#https://codereview.stackexchange.com/questions/35267/writing-integer-to-binary-file
def random(min, max):
	range = max - min + 1
	RawData = open("/dev/urandom", "rb").read(4)
	HexData = "".join(['{0:0x}'.format(ord(b)) for b in RawData])
	return (int(HexData, 16) % range) + min

def drawLine(x, y, r, g, b, width, angle, distance):
	t.pencolor((r, g, b))
	t.up()
	t.goto(x, y)
	t.width(width)
	t.setheading(0)
	t.left(angle)
	t.down()
	t.forward(distance)

#Initialization
t = turtle.Turtle()
screen = t.getscreen()
t.speed(0)
screen.colormode(255)

#generate a sequence of lines
r = [random(0, 255)]
g = [random(0, 255)]
b = [random(0, 255)]
x = [0]
y = [0]
width = [random(0, 100)]
angle = [random(0, 360)]
distance = [random(0, 100)]

for i in range(random(80, 150)):
	x.append(x[i] + random(-100, 100))
	y.append(y[i] + random(-100, 100))
	r.append((r[i] + random(0, 5)) % 255)
	g.append((g[i] + random(0, 5)) % 255)
	b.append((b[i] + random(0, 5)) % 255)
	width.append(random(0, 100))
	angle.append(random(0, 360))
	distance.append(random(0, 100))

#calculate the size of the Window
minX = min(x)
minY = min(y)
maxX = max(x)
maxY = max(y)

if -minX > maxX:
	screenSizeX = -minX*2 + 150
else:
	screenSizeX = maxX*2 + 150

screen.setup(width=screenSizeX, height=(maxY - minY + 150))

#middle of the screen, so it can be centered vertically
middleY = (maxY + minY) / 2

#the actual drawing
for i in range(len(y)):
	y[i] -= middleY
	drawLine(x[i], y[i], r[i], g[i], b[i], width[i], angle[i], distance[i])
	drawLine(-x[i], y[i], r[i], g[i], b[i], width[i], -(angle[i] - 180), distance[i])

#move the turtle out of sight
t.up()
t.goto(5000, 5000)

turtle.exitonclick()
