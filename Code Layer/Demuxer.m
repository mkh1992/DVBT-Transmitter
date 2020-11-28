function toBitinterleaver = Demuxer(todemux,v)
switch v
    case 'QPSK'
        b(1,:) = todemux(1:2:end);
        b(2,:) = todemux(2:2:end);
    case '16QAM'
        b(1,:) = todemux(1:4:end);
        b(2,:) = todemux(3:4:end);
        b(3,:) = todemux(2:4:end);
        b(4,:) = todemux(4:4:end);
    case '64QAM'
        b(1,:) = todemux(1:6:end);
        b(2,:) = todemux(4:6:end);
        b(3,:) = todemux(2:6:end);
        b(4,:) = todemux(5:6:end);
        b(5,:) = todemux(3:6:end);
        b(6,:) = todemux(6:6:end);
end
toBitinterleaver = b;

        
