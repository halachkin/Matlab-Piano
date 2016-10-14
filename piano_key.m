function s = piano_key(n)
    
    global Fs;
    global t;
    global tlen;
    global exp_mult;
    global overtone;

    % compute key frequency 
    % % https://en.wikipedia.org/wiki/Piano_key_frequencies
    f = 2^((n-49)/12) * 440; 
    
    % first harmonic
    s = sin(1 * 2*pi * f*t);
    
    %add overtones
    An = [4 4 4 4 4 8 8 32 32];
    for i = 1:length(An)
        s = s + overtone * 0.4 / An(i) * sin( (i+1) * 2*pi*f*t );
    end
 
    
    if(n > 60)
        s = 0.3*s;
    end
    if(n > 80)
        s = 0.3*s;
    end

    % attenuation
    s = s .* exp_mult;
    
    % normalize
    s = s / max(abs(s));

