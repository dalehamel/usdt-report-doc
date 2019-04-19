## Shared library stub

Upon registering a provider, we can see that libstapsdt has created a stub library by listing the tracepoints of the process:

```
tplist -p 7371
/tmp/pythonapp-7QYyFE.so pythonapp:firstProbe
```

If we inspect this stub library, we can see that the probe definition is in the ELF notes section:


// FIXME store this externally
```
readelf --notes /tmp/pythonapp-7QYyFE.so

Displaying notes found in: .note.stapsdt
  Owner                 Data size       Description
  stapsdt              0x0000003c       NT_STAPSDT (SystemTap probe descriptors)
    Provider: pythonapp
    Name: firstProbe
    Location: 0x0000000000000260, Base: 0x0000000000000318, Semaphore: 0x0000000000000000
    Arguments: 8@%rdi -4@%rsi
```
