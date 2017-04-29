import gov.nist.microanalysis.EPQLibrary as epq

# Density from Probe Software, compo from NIST spectrum
k412 = epq.Material(epq.Composition([epq.Element.O,
                                     epq.Element.Mg,
                                     epq.Element.Al,
                                     epq.Element.Si,
                                     epq.Element.Ca,                                    
                                     epq.Element.Fe],
                                    [ 0.4276,
                                      0.1166,
                                      0.0491,
                                      0.2120,
                                      0.1090,
                                      0.0774]
                                      ),
                                    epq.ToSI.gPerCC(2.600))
k412.setName("K412")

