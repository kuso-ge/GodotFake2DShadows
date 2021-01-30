# GodotFake2DShadows

Disclaimer:

This method uses draw_primitive to draw a copy of your Sprite, so in essence it really is a fake shadow that doesn't interact with the environment. 
I haven't tested if a shader version of this is faster. This was just a proof of concept for 2d fake projected shadows. 

So how does this work?

First let's look at the main function that makes this possible:
```
draw_primitive(points, colors, uvs, texture)
```
the first parameter refers to the four points of how the texture is going to be drawn. 
```
p1 = Vector2() #topleft
p2 = Vector2() #topright
p3 = Vector2() #bottomRight
p4 = Vector2() #bottomLeft
points = [p1,p2,p3,p4]
```
Each point(p1,..,p4) is a Vector containing the (x,y) coordinate. 
We manipulate those points to skew or stretch the rendered texture. 

You can visually confirm how it works using a cartesian plane:

![alt text](https://i.imgur.com/lMuUqZE.png)

where:
```
p1 = Vector2(3,2)
p2 = Vector2(8,2)
p3 = Vector2(8,6)
p4 = Vector2(3,6)
```

Now, instead of using those values. We use the values retrieved from the $Sprite.texture (for example if it has the size of [64x64])
```
p1 = Vector2(-64,-64) 
p2 = Vector2(64,-64)
p3 = Vector2(64,64)
p4 = Vector2(-64,64)
```

However! The sprite is drawn starting from the origin of the object and not on global coordinates. 
Also, if you look at the values, it would essentially create a 128x128 texture!!
Why is this? Well, let's look at the values we used.

![alt text](https://i.imgur.com/dvWaCgu.png)

So we divide the $Sprite width and height by 2, so we get these values:
```
p1 = Vector2(-32,-32) 
p2 = Vector2(32,-32)
p3 = Vector2(32,32)
p4 = Vector2(-32,32)
```
Which should get us an exact copy of the orignal Sprite's size. 
Now that we have the base values/coordinates/points for our Shadow sprites, we use fancy math to manipulate those points and move them around!

```
var offset_topLeft = Vector2()
var offset_topRight = Vector2()
var offset_bottomRight = Vector2()
var offset_bottomLeft = Vector2()

## some code goes here

p1 = Vector2(-32,-32) + offset_topLeft
p2 = Vector2(32,-32) + offset_topRight
p3 = Vector2(32,32) + offset_bottomRight
p4 = Vector2(-32,32) + offset_bottomLeft
```

Any values we plug in to the offset vectors should allow us to move the drawn texture(shadow) anywhere we want and we can even SKEW the drawn shadow too!
By now we should have a drawn texture(shadow) faithfully following the main node/object/unit and skewed and positioned with however we wanted using the offset vectors. 
But something still looks off, most specially if we want to make the Sprite Jump in 2d top down world! 

Now the math here would depend on where you want the Shadow to be cast,(the location of our imaginary sun/light, and whether it is local spot light or a global sun light). 
For a spot light effect, we could do
```
var light_vector = spot_light.global_position() - unit.global_position()
```
Then we subract the light_vector to the top parts of the shadow/texture to make the top part move away from the spot_light:
```
p1 = Vector(-32,-32) - light_vector
p2 = Vector2(32,-32) - light_vector 
```
But how or why does the top part move away from the spotlight when we do this? It's simple.

![alt text](https://i.imgur.com/YrXUr92.png)


You can always buy me a coffee if this article/repo helped @ https://ko-fi.com/myiasis

//TODO: I'll continue the rest when I get another free time (cries in the corner)
