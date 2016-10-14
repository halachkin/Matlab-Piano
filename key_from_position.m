function n = key_from_position(x, y)
% input x,y - mouse position, n - piano key
    global piano_img
    global white_keys
    global black_keys

    if(x > 599) 
       x = 599;
    end
    if(x < 0)
       x = 0;
    end   
    
    % white key width
    wh_key_width =  600/52;
    octave_width = wh_key_width * 7;
    if( mean(piano_img(round(y), round(x), :)) < 10 && y < 48)
    % black key case
        if( x < wh_key_width *2)
            n = black_keys(1);
        else
        % compute octave
            %octave - 1
            octave = floor( (x - 2 * wh_key_width) / (600 - 3 * wh_key_width) * 7); 
            offset = 2 * wh_key_width + octave_width * octave;
            if( x < offset + 1.5 * wh_key_width)
                n = black_keys(2 + octave * 5);
            elseif( x < offset + 2.5 * wh_key_width) 
                n = black_keys(3 + octave * 5);
            elseif( x < offset + 4.5 * wh_key_width) 
                n = black_keys(4 + octave * 5);
            elseif( x < offset + 5.5 * wh_key_width) 
                n = black_keys(5 + octave * 5);
            else
                n = black_keys(6 + octave * 5);
            end
        end
    else
    % white key case
        n = white_keys(floor(x / wh_key_width ) + 1);
    end  
    
   
end
