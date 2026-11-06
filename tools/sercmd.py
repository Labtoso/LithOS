import socket,time,sys
s=socket.socket(socket.AF_UNIX);s.connect('/tmp/ser.sock');s.settimeout(1)
def rd(t):
    out=b'';end=time.time()+t
    while time.time()<end:
        try: out+=s.recv(65536)
        except socket.timeout: pass
    return out.decode('utf8','replace')
for c in sys.argv[1:]:
    s.send((c+'\n').encode()); 
print(rd(float(__import__('os').environ.get('W','8'))))
