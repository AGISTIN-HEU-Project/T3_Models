function [ pu ] = pu( Sb, VLLrms, omegab )
%PU returns pu base quantities for Sb, Vb
%   Sb: base Power in VA
%   VLLrms: delta RMS voltage in V
%   omegab: base frequency in rad/s
pu.Vb = VLLrms/sqrt(3)*sqrt(2); % Line-Line RMS ==> Line-Neutral Amplitude
pu.Ub = pu.Vb; %bezeichnung U und V wird beides verwendet; 
pu.Sb = Sb;
pu.omegab = omegab;
pu.Ib = 2*pu.Sb/3/pu.Vb;
pu.Zb = pu.Vb/pu.Ib;
pu.Cb = 1/pu.Zb/omegab;
pu.Lb = pu.Zb/omegab;
end

