function kern = gabCurve(stdDev,curveAngle,lambda,psi, radius, arcAngle)

    kernScale = 4; % Magic number. This is here so the circle is smoother

    gab = gabor_patch(stdDev, 0, lambda, psi , 1);

    arcAngleDeg = arcAngle*(180/pi);

    %arcAngle = arcAngleDeg*(pi/180);

    xGab = size(gab,2)*kernScale
    yGab = size(gab,1)*kernScale

    
    if arcAngleDeg <= 180
        kernHeight = (abs(2*radius*sin(arcAngle/2))*kernScale + yGab)
        kernWidth = (abs(radius*(1-cos(arcAngle/2)))*kernScale + xGab)
    else
        kernHeight = 2*radius*kernScale + yGab
        kernWidth = (abs(radius*(cos(arcAngle/2)))*kernScale + xGab)
    end

    kernSize = ceil([kernHeight kernWidth] + [yGab xGab])

    kern__ = zeros(kernSize);

    for i = 1:10:(radius*kernScale)

        kernAngle = arcAngle*( (i/(radius*kernScale)) - 0.5 );

        xPos = floor(radius*kernScale*(cos(kernAngle)) - kernWidth/2 + xGab);
        yPos = floor(radius*kernScale*(sin(kernAngle)) - kernHeight/2 + yGab);
        [xPos yPos]
        kern__(yPos:(yPos+yGab-1),xPos:(xPos+xGab-1)) = kern__(yPos:(yPos+yGab-1),xPos:(xPos+xGab-1)) + imrotate(imresize(gab,kernScale),(kernAngle)*(180/pi),'bilinear','crop');
    
    end

    
%     curveAngle = 0;
    if curveAngle ~= 0
        kern_ = imrotate(kern__,-curveAngle);
    else
        kern_ = kern__;
    end
    
    %figure, imshow(kern_);

    kern = imresize(kern_, 1/kernScale);

end
