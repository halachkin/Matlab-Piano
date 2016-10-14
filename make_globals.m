function make_globals(init)

global Fs;
global t;
global tlen;
global attenuation_coef;
global exp_mult;
global overtone;
global white_keys;
global black_keys;
global piano_img;
global mapper;

if(init)
    Fs = 8000;
    tlen = 2.5;
    overtone = 1.0;
    attenuation_coef = 10;
end
t = linspace(0, tlen, tlen*Fs);
exp_mult = exp(-t*attenuation_coef);

% https://en.wikipedia.org/wiki/Piano_key_frequencies
white_keys = [1 3 4 6 8 9 11 13 15 16 18 20 21 23 25 ...
             27 28 30 32 33 35 37 39 40 42 44 45 47 ...
             49 51 52 54 56 57 59 61 63 64 66 68 69 ...
             71 73 75 76 78 80 81 83 85 87 88];
         
black_keys = [2 5 7 10 12 14 17 19 22 24 26 29 31 34 36 38 ...
              41 43 46 48 50 53 55 58 60 62 65 67 ...
              70 72 74 77 79 82 84 86];
          
piano_img = imread('piano.png');
          
keyboard =   {'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8', 'f9', 'f10' ...
               '1',  '2',   '3',  '4', '5',  '6',  '7',  '8',  '9',  '0', ...
               'q',  'w',   'e',  'r', 't',  'y',  'u',  'i',  'o',  'p', ...
               'a',  's',   'd',  'f', 'g',  'h',  'j',  'k',  'l', ...
               'z',  'x',   'c',  'v', 'b',  'n',  'm',  ',',  '.' };

piano_keys = linspace(1, length(keyboard),length(keyboard)); 
mapper = containers.Map(keyboard, piano_keys) ;       

end