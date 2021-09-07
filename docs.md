General CLI tips and tricks:
https://github.com/Nuand/bladeRF/wiki/bladeRF-CLI-Tips-and-Tricks#using-an-external-clock-input

Discusses bladeRF clock in and out
https://github.com/Nuand/bladeRF/wiki/bladeRF-CLI-Tips-and-Tricks#using-an-external-clock-input

IQ imbalance correction:
https://github.com/Nuand/bladeRF/wiki/DC-offset-and-IQ-Imbalance-Correction#correcting-the-tx-module

---
## Matlab scripts

https://github.com/Nuand/bladeRF/tree/master/host/misc/matlab

**load_csv.m**          
https://github.com/Nuand/bladeRF/blob/master/host/misc/matlab/load_csv.m
                    Read a normalized complex signal from a CSV file
                    with integer bladeRF "SC16 Q11" values.

load_grcomplex.m    https://github.com/Nuand/bladeRF/blob/master/host/misc/matlab/load_grcomplex.m
                    Read a complex signal from a binary file containing
                    complex float samples saved using GNU Radio.

load_sc16q11.m      https://github.com/Nuand/bladeRF/blob/master/host/misc/matlab/load_sc16q11.m
                    Read a normalized complex signal from a binary file in the 
                    bladeRF "SC16 Q11" format.

save_csv.m          https://github.com/Nuand/bladeRF/blob/master/host/misc/matlab/save_csv.m
                    Write a normalized complex signal to a CSV file in the
                    as integer bladeRF "SC16 Q11" values.

save_grcomplex.m    https://github.com/Nuand/bladeRF/blob/master/host/misc/matlab/save_grcomplex.m
                    Write a normalized complex signal to a binary file in the
                    GNU Radio complex float format.

save_sc16q11.m      https://github.com/Nuand/bladeRF/blob/master/host/misc/matlab/save_sc16q11.m
                    Write a normalized complex signal to a binary file in the
                    bladeRF "SC16 Q11" format.



## Loopback tests

TODO


# Transmitting

See https://github.com/Nuand/bladeRF/wiki/bladeRF-CLI-Tips-and-Tricks#transmitting-pre-generated-samples

[Transmitting Pre-generated Samples](https://github.com/Nuand/bladeRF/wiki/bladeRF-CLI-Tips-and-Tricks#Transmitting_Pregenerated_Samples)
[Example: Transmitting Samples Generated in Octave/MATLAB](https://github.com/Nuand/bladeRF/wiki/bladeRF-CLI-Tips-and-Tricks#Example_Transmitting_Samples_Generated_in_OctaveMATLAB)


# DVB-T

See DVB testing notes [here](DVB-T/README.md)