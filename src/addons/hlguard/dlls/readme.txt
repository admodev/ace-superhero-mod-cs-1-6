//====================================//
// Explanation of .dll and .so files. //
//====================================//

hlguard_mm.dll and hlguard_mm_i586.so both use the i586 architecture which can be used on
Intel Pentium and AMD K6 CPU's and above.

hlguard_mm_i686.dll and hlguard_mm_i686.so use i686 architecture, which can be used on Intel
PentiumII/pro and AMD Athlons CPU's and above.

You should get better performance out of using the i686 binary, so if you have a cpu pentiumII/pro
or Athlon and better, use the i686 binary.  Remember, when using the i686 binary in windows,
you either have to alter your plugins.ini file to reflect the different file name, or rename the file
to hlguard_mm.dll for it to work.

If after all this you are quite confused, just use the hlguard_mm.dll (for windows) or
hlguard_mm_i586.so (for linux) files.  They will work for more cpu's.