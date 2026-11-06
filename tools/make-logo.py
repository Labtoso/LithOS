from PIL import Image, ImageDraw
def logo(size):
    S=4; W=size*S; k=W/256
    im=Image.new('RGBA',(W,W),(0,0,0,0)); d=ImageDraw.Draw(im)
    for x,y,w,h,c in [(34,176,188,54,'#1E3A8A'),(56,118,144,50,'#2563EB'),(82,64,92,46,'#3B82F6')]:
        d.rounded_rectangle([x*k,y*k,(x+w)*k,(y+h)*k],radius=h/2*k,fill=c)
    d.ellipse([(128-20)*k,(36-20)*k,(128+20)*k,(36+20)*k],fill='#60A5FA')
    return im.resize((size,size),Image.LANCZOS)
for s in [16,32,48,64,128,256,512,1024]:
    logo(s).save(f'lithos-logo-{s}.png')
# Vorschau auf dunkel
bg=Image.new('RGBA',(1500,560),'#0d1117'); x=20
for s in [64,128,256,512]:
    bg.alpha_composite(logo(s),(x,(560-s)//2)); x+=s+40
bg.convert('RGB').save('vorschau.png')
from PIL import ImageFont
def wordmark(h):
    S=4; k=h*S/256; W=int(760*k); im=Image.new('RGBA',(W,h*S),(0,0,0,0))
    im.alpha_composite(logo(h*S)); d=ImageDraw.Draw(im)
    f=ImageFont.truetype('/usr/share/fonts/opentype/inter/Inter-SemiBold.otf',int(120*k))
    x=262*k; d.text((x,172*k),'Lith',font=f,fill='#E5E7EB',anchor='ls')
    x+=d.textlength('Lith',font=f); d.text((x,172*k),'OS',font=f,fill='#3B82F6',anchor='ls')
    return im.resize((W//S,h),Image.LANCZOS)
wordmark(256).save('lithos-logo-schriftzug-256.png'); wordmark(512).save('lithos-logo-schriftzug-512.png')
b=Image.new('RGBA',(760,256),'#0d1117'); b.alpha_composite(wordmark(256)); b.save('LithOS-Logo-final.png')
