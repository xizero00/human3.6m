function imorig = Dragos_CFA2RGB( imorig )
% addpath('./Tool_Cameras');
% addpath('./Tool_Cameras/LASIP');
% addpath('./Tool_Cameras/LASIP_cfai');

imcolormask(2,2,:) = [0 1 0];
imcolormask(1,1,:) = [0 1 0];
imcolormask(1,2,:) = [0 0 1];
imcolormask(2,1,:) = [1 0 0];

[H,W,~] = size(imorig);
imorig = repmat(double(imorig)/255, [1 1 3]) .* repmat(imcolormask, [H/2 W/2 1]);

Z = imorig(:,:,1);
imorig(:,:,1) = imorig(:,:,3);
imorig(:,:,3) = Z;

%imorig = function_cfai_lpaici(imorig,1);
imorig = function_cfai_ha(imorig,1);

% ------------------------------------
% Results
% ------------------------------------
imorig = min(max(imorig,0),1);

Z = imorig(:,:,1);
imorig(:,:,1) = imorig(:,:,3);
imorig(:,:,3) = Z;

return

[H, W, ~] = size(imorig);
  %{
  %Red
  imorig(2:2:end,2:2:end-1,1) = 0.5 * (imorig(2:2:end,1:2:end-2,1) + imorig(2:2:end,3:2:end,1));
  imorig(3:2:end-1,1:end-1,1) = 0.5 * (imorig(2:2:end-2,1:end-1,1) + imorig(4:2:end,1:end-1,1));
  imorig(2:end,end,1) = imorig(2:end,end-1,1); 
  imorig(1,:,1) = imorig(2,:,1);
  
  %Blue
  imorig(1:2:end,3:2:end-1,3) = 0.5 * (imorig(1:2:end,2:2:end-2,3) + imorig(1:2:end,4:2:end,3));
  imorig(2:2:end-1,2:end,3) = 0.5 * (imorig(1:2:end-2,2:end,3) + imorig(3:2:end,2:end,3));
  imorig(1:end-1,1,3) = imorig(1:end-1,2,3); 
  imorig(end,:,3) = imorig(end-1,:,3); 
  %}

  
  %Green
%  imorig(2:2:end-1,3:2:end-1,2) = 0.25 * (imorig(1:2:end-2,3:2:end-1,2) + imorig(3:2:end,3:2:end-1,2) + imorig(2:2:end-1,2:2:end-2,2) + imorig(2:2:end-1,4:2:end,2));
%  imorig(3:2:end-1,2:2:end-1,2) = 0.25 * (imorig(2:2:end-2,2:2:end-1,2) + imorig(4:2:end,2:2:end-1,2) + imorig(3:2:end-1,1:2:end-2,2) + imorig(3:2:end-1,3:2:end,2));


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Reconstruct RGB image from CFA %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % http://www.eurasip.org/Proceedings/Eusipco/Eusipco2004/defevent/papers/cr1452.pdf
  %Green diamond
  for s = 2:2:W-2
      for r = 3:2:H-1
         u =[1 / (1 + abs(imorig(r-1,s,2) - imorig(r,s-1,2)) + abs(imorig(r-1,s,2) - imorig(r,s+1,2)) + abs(imorig(r-1,s,2) - imorig(r+1,s,2))), ...
             1 / (1 + abs(imorig(r,s-1,2) - imorig(r-1,s,2)) + abs(imorig(r,s-1,2) - imorig(r+1,s,2)) + abs(imorig(r,s-1,2) - imorig(r,s+1,2))), ...
             1 / (1 + abs(imorig(r,s+1,2) - imorig(r,s-1,2)) + abs(imorig(r,s+1,2) - imorig(r-1,s,2)) + abs(imorig(r,s+1,2) - imorig(r+1,s,2))), ...
             1 / (1 + abs(imorig(r+1,s,2) - imorig(r,s-1,2)) + abs(imorig(r+1,s,2) - imorig(r,s+1,2)) + abs(imorig(r+1,s,2) - imorig(r-1,s,2)))];
         u = u / sum(u);
         imorig(r,s,2) = imorig(r-1,s,2) * u(1) + imorig(r,s-1,2) * u(2) + imorig(r,s+1,2) * u(3) + imorig(r+1,s,2) * u(4);

         s1 = s+1;
         r1 = r-1;
         u =[1 / (1 + abs(imorig(r1-1,s1,2) - imorig(r1,s1-1,2)) + abs(imorig(r1-1,s1,2) - imorig(r1,s1+1,2)) + abs(imorig(r1-1,s1,2) - imorig(r1+1,s1,2))), ...
             1 / (1 + abs(imorig(r1,s1-1,2) - imorig(r1-1,s1,2)) + abs(imorig(r1,s1-1,2) - imorig(r1+1,s1,2)) + abs(imorig(r1,s1-1,2) - imorig(r1,s1+1,2))), ...
             1 / (1 + abs(imorig(r1,s1+1,2) - imorig(r1,s1-1,2)) + abs(imorig(r1,s1+1,2) - imorig(r1-1,s1,2)) + abs(imorig(r1,s1+1,2) - imorig(r1+1,s1,2))), ...
             1 / (1 + abs(imorig(r1+1,s1,2) - imorig(r1,s1-1,2)) + abs(imorig(r1+1,s1,2) - imorig(r1,s1+1,2)) + abs(imorig(r1+1,s1,2) - imorig(r1-1,s1,2)))];
         u = u / sum(u);
         imorig(r1,s1,2) = imorig(r1-1,s1,2) * u(1) + imorig(r1,s1-1,2) * u(2) + imorig(r1,s1+1,2) * u(3) + imorig(r1+1,s1,2) * u(4);
      end
  end
  %Red&blue square
  for s = 2:2:W-2
      for r = 3:2:H-1
         %Red
         u =[1 / (1 + abs(imorig(r-1,s-1,1) - imorig(r-1,s+1,1)) + abs(imorig(r-1,s-1,1) - imorig(r+1,s-1,1)) + abs(imorig(r-1,s-1,1) - imorig(r+1,s+1,1))), ...
             1 / (1 + abs(imorig(r-1,s+1,1) - imorig(r-1,s-1,1)) + abs(imorig(r-1,s+1,1) - imorig(r+1,s-1,1)) + abs(imorig(r-1,s+1,1) - imorig(r+1,s+1,1))), ...
             1 / (1 + abs(imorig(r+1,s-1,1) - imorig(r-1,s-1,1)) + abs(imorig(r+1,s-1,1) - imorig(r-1,s+1,1)) + abs(imorig(r+1,s-1,1) - imorig(r+1,s+1,1))), ...
             1 / (1 + abs(imorig(r+1,s+1,1) - imorig(r-1,s-1,1)) + abs(imorig(r+1,s+1,1) - imorig(r-1,s+1,1)) + abs(imorig(r+1,s+1,1) - imorig(r+1,s-1,1)))];
         u = u / sum(u);
         imorig(r,s,1) = imorig(r,s,2) * (u(1) * imorig(r-1,s-1,1)/imorig(r-1,s-1,2) + u(2) * imorig(r-1,s+1,1)/imorig(r-1,s+1,2) + u(3) * imorig(r+1,s-1,1)/imorig(r+1,s-1,2) + u(4) * imorig(r+1,s+1,1)/imorig(r+1,s+1,2));
         
         %Blue
         s1 = s+1;
         r1 = r-1;
         u =[1 / (1 + abs(imorig(r1-1,s1-1,3) - imorig(r1-1,s1+1,3)) + abs(imorig(r1-1,s1-1,3) - imorig(r1+1,s1-1,3)) + abs(imorig(r1-1,s1-1,3) - imorig(r1+1,s1+1,3))), ...
             1 / (1 + abs(imorig(r1-1,s1+1,3) - imorig(r1-1,s1-1,3)) + abs(imorig(r1-1,s1+1,3) - imorig(r1+1,s1-1,3)) + abs(imorig(r1-1,s1+1,3) - imorig(r1+1,s1+1,3))), ...
             1 / (1 + abs(imorig(r1+1,s1-1,3) - imorig(r1-1,s1-1,3)) + abs(imorig(r1+1,s1-1,3) - imorig(r1-1,s1+1,3)) + abs(imorig(r1+1,s1-1,3) - imorig(r1+1,s1+1,3))), ...
             1 / (1 + abs(imorig(r1+1,s1+1,3) - imorig(r1-1,s1-1,3)) + abs(imorig(r1+1,s1+1,3) - imorig(r1-1,s1+1,3)) + abs(imorig(r1+1,s1+1,3) - imorig(r1+1,s1-1,3)))];
         u = u / sum(u);
         imorig(r1,s1,3) = imorig(r1,s1,2) * (u(1) * imorig(r1-1,s1-1,3)/imorig(r1-1,s1-1,2) + u(2) * imorig(r1-1,s1+1,3)/imorig(r1-1,s1+1,2) + u(3) * imorig(r1+1,s1-1,3)/imorig(r1+1,s1-1,2) + u(4) * imorig(r1+1,s1+1,3)/imorig(r1+1,s1+1,2));
      end
  end
  %Red&blue diamond
  for s = 2:2:W-2
      for r = 2:2:H-2
         u =[1 / (1 + abs(imorig(r-1,s,1) - imorig(r,s-1,1)) + abs(imorig(r-1,s,1) - imorig(r,s+1,1)) + abs(imorig(r-1,s,1) - imorig(r+1,s,1))), ...
             1 / (1 + abs(imorig(r,s-1,1) - imorig(r-1,s,1)) + abs(imorig(r,s-1,1) - imorig(r+1,s,1)) + abs(imorig(r,s-1,1) - imorig(r,s+1,1))), ...
             1 / (1 + abs(imorig(r,s+1,1) - imorig(r,s-1,1)) + abs(imorig(r,s+1,1) - imorig(r-1,s,1)) + abs(imorig(r,s+1,1) - imorig(r+1,s,1))), ...
             1 / (1 + abs(imorig(r+1,s,1) - imorig(r,s-1,1)) + abs(imorig(r+1,s,1) - imorig(r,s+1,1)) + abs(imorig(r+1,s,1) - imorig(r-1,s,1)))];
         u = u / sum(u);
         imorig(r,s,1) = imorig(r,s,2) * (u(1) * imorig(r-1,s,1)/imorig(r-1,s,2) + u(2) * imorig(r,s-1,1)/imorig(r,s-1,2) + u(3) * imorig(r,s+1,1)/imorig(r,s+1,2) + u(4) * imorig(r+1,s,1)/imorig(r+1,s,2));
         u =[1 / (1 + abs(imorig(r-1,s,3) - imorig(r,s-1,3)) + abs(imorig(r-1,s,3) - imorig(r,s+1,3)) + abs(imorig(r-1,s,3) - imorig(r+1,s,3))), ...
             1 / (1 + abs(imorig(r,s-1,3) - imorig(r-1,s,3)) + abs(imorig(r,s-1,3) - imorig(r+1,s,3)) + abs(imorig(r,s-1,3) - imorig(r,s+1,3))), ...
             1 / (1 + abs(imorig(r,s+1,3) - imorig(r,s-1,3)) + abs(imorig(r,s+1,3) - imorig(r-1,s,3)) + abs(imorig(r,s+1,3) - imorig(r+1,s,3))), ...
             1 / (1 + abs(imorig(r+1,s,3) - imorig(r,s-1,3)) + abs(imorig(r+1,s,3) - imorig(r,s+1,3)) + abs(imorig(r+1,s,3) - imorig(r-1,s,3)))];
         u = u / sum(u);
         imorig(r,s,3) = imorig(r,s,2) * (u(1) * imorig(r-1,s,3)/imorig(r-1,s,2) + u(2) * imorig(r,s-1,3)/imorig(r,s-1,2) + u(3) * imorig(r,s+1,3)/imorig(r,s+1,2) + u(4) * imorig(r+1,s,3)/imorig(r+1,s,2));
         
         s1 = s+1;
         r1 = r+1;
         u =[1 / (1 + abs(imorig(r1-1,s1,1) - imorig(r1,s1-1,1)) + abs(imorig(r1-1,s1,1) - imorig(r1,s1+1,1)) + abs(imorig(r1-1,s1,1) - imorig(r1+1,s1,1))), ...
             1 / (1 + abs(imorig(r1,s1-1,1) - imorig(r1-1,s1,1)) + abs(imorig(r1,s1-1,1) - imorig(r1+1,s1,1)) + abs(imorig(r1,s1-1,1) - imorig(r1,s1+1,1))), ...
             1 / (1 + abs(imorig(r1,s1+1,1) - imorig(r1,s1-1,1)) + abs(imorig(r1,s1+1,1) - imorig(r1-1,s1,1)) + abs(imorig(r1,s1+1,1) - imorig(r1+1,s1,1))), ...
             1 / (1 + abs(imorig(r1+1,s1,1) - imorig(r1,s1-1,1)) + abs(imorig(r1+1,s1,1) - imorig(r1,s1+1,1)) + abs(imorig(r1+1,s1,1) - imorig(r1-1,s1,1)))];
         u = u / sum(u);
         imorig(r1,s1,1) = imorig(r1,s1,2) * (u(1) * imorig(r1-1,s1,1)/imorig(r1-1,s1,2) + u(2) * imorig(r1,s1-1,1)/imorig(r1,s1-1,2) + u(3) * imorig(r1,s1+1,1)/imorig(r1,s1+1,2) + u(4) * imorig(r1+1,s1,1)/imorig(r1+1,s1,2));
         u =[1 / (1 + abs(imorig(r1-1,s1,3) - imorig(r1,s1-1,3)) + abs(imorig(r1-1,s1,3) - imorig(r1,s1+1,3)) + abs(imorig(r1-1,s1,3) - imorig(r1+1,s1,3))), ...
             1 / (1 + abs(imorig(r1,s1-1,3) - imorig(r1-1,s1,3)) + abs(imorig(r1,s1-1,3) - imorig(r1+1,s1,3)) + abs(imorig(r1,s1-1,3) - imorig(r1,s1+1,3))), ...
             1 / (1 + abs(imorig(r1,s1+1,3) - imorig(r1,s1-1,3)) + abs(imorig(r1,s1+1,3) - imorig(r1-1,s1,3)) + abs(imorig(r1,s1+1,3) - imorig(r1+1,s1,3))), ...
             1 / (1 + abs(imorig(r1+1,s1,3) - imorig(r1,s1-1,3)) + abs(imorig(r1+1,s1,3) - imorig(r1,s1+1,3)) + abs(imorig(r1+1,s1,3) - imorig(r1-1,s1,3)))];
         u = u / sum(u);
         imorig(r1,s1,3) = imorig(r1,s1,2) * (u(1) * imorig(r1-1,s1,3)/imorig(r1-1,s1,2) + u(2) * imorig(r1,s1-1,3)/imorig(r1,s1-1,2) + u(3) * imorig(r1,s1+1,3)/imorig(r1,s1+1,2) + u(4) * imorig(r1+1,s1,3)/imorig(r1+1,s1,2));       
      end
  end
  
  imorig = imorig(4:end-4, 4:end-4,:);
  
  return;
  
  %%%%%%%%%%%%%%%%%%%%
  % Color correction %
  %%%%%%%%%%%%%%%%%%%%
  %Green diamond
  for s = 2:2:W-1
      for r = 3:2:H-1
         u =[1 / (1 + abs(imorig(r-1,s,2) - imorig(r,s-1,2)) + abs(imorig(r-1,s,2) - imorig(r,s+1,2)) + abs(imorig(r-1,s,2) - imorig(r+1,s,2))), ...
             1 / (1 + abs(imorig(r,s-1,2) - imorig(r-1,s,2)) + abs(imorig(r,s-1,2) - imorig(r+1,s,2)) + abs(imorig(r,s-1,2) - imorig(r,s+1,2))), ...
             1 / (1 + abs(imorig(r,s+1,2) - imorig(r,s-1,2)) + abs(imorig(r,s+1,2) - imorig(r-1,s,2)) + abs(imorig(r,s+1,2) - imorig(r+1,s,2))), ...
             1 / (1 + abs(imorig(r+1,s,2) - imorig(r,s-1,2)) + abs(imorig(r+1,s,2) - imorig(r,s+1,2)) + abs(imorig(r+1,s,2) - imorig(r-1,s,2)))];
         u = u / sum(u);
         imorig(r,s,2) = imorig(r,s,1) * (u(1) * imorig(r-1,s,2)/imorig(r-1,s,1) + u(2) * imorig(r,s-1,2)/imorig(r,s-1,1) + u(3) * imorig(r,s+1,2)/imorig(r,s+1,1) + u(4) * imorig(r+1,s,2)/imorig(r+1,s,1));
      end
  end
  for s = 3:2:W-1
      for r = 2:2:H-1
         u =[1 / (1 + abs(imorig(r-1,s,2) - imorig(r,s-1,2)) + abs(imorig(r-1,s,2) - imorig(r,s+1,2)) + abs(imorig(r-1,s,2) - imorig(r+1,s,2))), ...
             1 / (1 + abs(imorig(r,s-1,2) - imorig(r-1,s,2)) + abs(imorig(r,s-1,2) - imorig(r+1,s,2)) + abs(imorig(r,s-1,2) - imorig(r,s+1,2))), ...
             1 / (1 + abs(imorig(r,s+1,2) - imorig(r,s-1,2)) + abs(imorig(r,s+1,2) - imorig(r-1,s,2)) + abs(imorig(r,s+1,2) - imorig(r+1,s,2))), ...
             1 / (1 + abs(imorig(r+1,s,2) - imorig(r,s-1,2)) + abs(imorig(r+1,s,2) - imorig(r,s+1,2)) + abs(imorig(r+1,s,2) - imorig(r-1,s,2)))];
         u = u / sum(u);
         imorig(r,s,2) = imorig(r,s,3) * (u(1) * imorig(r-1,s,2)/imorig(r-1,s,3) + u(2) * imorig(r,s-1,2)/imorig(r,s-1,3) + u(3) * imorig(r,s+1,2)/imorig(r,s+1,3) + u(4) * imorig(r+1,s,2)/imorig(r+1,s,3));
      end
  end
  %Red square
  for s = 2:2:W-1
      for r = 3:2:H-1
         u =[1 / (1 + abs(imorig(r-1,s-1,1) - imorig(r-1,s+1,1)) + abs(imorig(r-1,s-1,1) - imorig(r+1,s-1,1)) + abs(imorig(r-1,s-1,1) - imorig(r+1,s+1,1))), ...
             1 / (1 + abs(imorig(r-1,s+1,1) - imorig(r-1,s-1,1)) + abs(imorig(r-1,s+1,1) - imorig(r+1,s-1,1)) + abs(imorig(r-1,s+1,1) - imorig(r+1,s+1,1))), ...
             1 / (1 + abs(imorig(r+1,s-1,1) - imorig(r-1,s-1,1)) + abs(imorig(r+1,s-1,1) - imorig(r-1,s+1,1)) + abs(imorig(r+1,s-1,1) - imorig(r+1,s+1,1))), ...
             1 / (1 + abs(imorig(r+1,s+1,1) - imorig(r-1,s-1,1)) + abs(imorig(r+1,s+1,1) - imorig(r-1,s+1,1)) + abs(imorig(r+1,s+1,1) - imorig(r+1,s-1,1)))];
         u = u / sum(u);
         imorig(r,s,1) = imorig(r,s,2) * (u(1) * imorig(r-1,s-1,1)/imorig(r-1,s-1,2) + u(2) * imorig(r-1,s+1,1)/imorig(r-1,s+1,2) + u(3) * imorig(r+1,s-1,1)/imorig(r+1,s-1,2) + u(4) * imorig(r+1,s+1,1)/imorig(r+1,s+1,2));
      end
  end
  %Blue square
  for s = 3:2:W-1
      for r = 2:2:H-1
         u =[1 / (1 + abs(imorig(r-1,s-1,3) - imorig(r-1,s+1,3)) + abs(imorig(r-1,s-1,3) - imorig(r+1,s-1,3)) + abs(imorig(r-1,s-1,3) - imorig(r+1,s+1,3))), ...
             1 / (1 + abs(imorig(r-1,s+1,3) - imorig(r-1,s-1,3)) + abs(imorig(r-1,s+1,3) - imorig(r+1,s-1,3)) + abs(imorig(r-1,s+1,3) - imorig(r+1,s+1,3))), ...
             1 / (1 + abs(imorig(r+1,s-1,3) - imorig(r-1,s-1,3)) + abs(imorig(r+1,s-1,3) - imorig(r-1,s+1,3)) + abs(imorig(r+1,s-1,3) - imorig(r+1,s+1,3))), ...
             1 / (1 + abs(imorig(r+1,s+1,3) - imorig(r-1,s-1,3)) + abs(imorig(r+1,s+1,3) - imorig(r-1,s+1,3)) + abs(imorig(r+1,s+1,3) - imorig(r+1,s-1,3)))];
         u = u / sum(u);
         imorig(r,s,3) = imorig(r,s,2) * (u(1) * imorig(r-1,s-1,3)/imorig(r-1,s-1,2) + u(2) * imorig(r-1,s+1,3)/imorig(r-1,s+1,2) + u(3) * imorig(r+1,s-1,3)/imorig(r+1,s-1,2) + u(4) * imorig(r+1,s+1,3)/imorig(r+1,s+1,2));
      end
  end
  %Red&blue diamond
  for s = 2:2:W-1
      for r = 2:2:H-1
         u =[1 / (1 + abs(imorig(r-1,s,1) - imorig(r,s-1,1)) + abs(imorig(r-1,s,1) - imorig(r,s+1,1)) + abs(imorig(r-1,s,1) - imorig(r+1,s,1))), ...
             1 / (1 + abs(imorig(r,s-1,1) - imorig(r-1,s,1)) + abs(imorig(r,s-1,1) - imorig(r+1,s,1)) + abs(imorig(r,s-1,1) - imorig(r,s+1,1))), ...
             1 / (1 + abs(imorig(r,s+1,1) - imorig(r,s-1,1)) + abs(imorig(r,s+1,1) - imorig(r-1,s,1)) + abs(imorig(r,s+1,1) - imorig(r+1,s,1))), ...
             1 / (1 + abs(imorig(r+1,s,1) - imorig(r,s-1,1)) + abs(imorig(r+1,s,1) - imorig(r,s+1,1)) + abs(imorig(r+1,s,1) - imorig(r-1,s,1)))];
         u = u / sum(u);
         imorig(r,s,1) = imorig(r,s,2) * (u(1) * imorig(r-1,s,1)/imorig(r-1,s,2) + u(2) * imorig(r,s-1,1)/imorig(r,s-1,2) + u(3) * imorig(r,s+1,1)/imorig(r,s+1,2) + u(4) * imorig(r+1,s,1)/imorig(r+1,s,2));
         u =[1 / (1 + abs(imorig(r-1,s,3) - imorig(r,s-1,3)) + abs(imorig(r-1,s,3) - imorig(r,s+1,3)) + abs(imorig(r-1,s,3) - imorig(r+1,s,3))), ...
             1 / (1 + abs(imorig(r,s-1,3) - imorig(r-1,s,3)) + abs(imorig(r,s-1,3) - imorig(r+1,s,3)) + abs(imorig(r,s-1,3) - imorig(r,s+1,3))), ...
             1 / (1 + abs(imorig(r,s+1,3) - imorig(r,s-1,3)) + abs(imorig(r,s+1,3) - imorig(r-1,s,3)) + abs(imorig(r,s+1,3) - imorig(r+1,s,3))), ...
             1 / (1 + abs(imorig(r+1,s,3) - imorig(r,s-1,3)) + abs(imorig(r+1,s,3) - imorig(r,s+1,3)) + abs(imorig(r+1,s,3) - imorig(r-1,s,3)))];
         u = u / sum(u);
         imorig(r,s,3) = imorig(r,s,2) * (u(1) * imorig(r-1,s,3)/imorig(r-1,s,2) + u(2) * imorig(r,s-1,3)/imorig(r,s-1,2) + u(3) * imorig(r,s+1,3)/imorig(r,s+1,2) + u(4) * imorig(r+1,s,3)/imorig(r+1,s,2));
      end
  end
  for s = 3:2:W-1
      for r = 3:2:H-1
         u =[1 / (1 + abs(imorig(r-1,s,1) - imorig(r,s-1,1)) + abs(imorig(r-1,s,1) - imorig(r,s+1,1)) + abs(imorig(r-1,s,1) - imorig(r+1,s,1))), ...
             1 / (1 + abs(imorig(r,s-1,1) - imorig(r-1,s,1)) + abs(imorig(r,s-1,1) - imorig(r+1,s,1)) + abs(imorig(r,s-1,1) - imorig(r,s+1,1))), ...
             1 / (1 + abs(imorig(r,s+1,1) - imorig(r,s-1,1)) + abs(imorig(r,s+1,1) - imorig(r-1,s,1)) + abs(imorig(r,s+1,1) - imorig(r+1,s,1))), ...
             1 / (1 + abs(imorig(r+1,s,1) - imorig(r,s-1,1)) + abs(imorig(r+1,s,1) - imorig(r,s+1,1)) + abs(imorig(r+1,s,1) - imorig(r-1,s,1)))];
         u = u / sum(u);
         imorig(r,s,1) = imorig(r,s,2) * (u(1) * imorig(r-1,s,1)/imorig(r-1,s,2) + u(2) * imorig(r,s-1,1)/imorig(r,s-1,2) + u(3) * imorig(r,s+1,1)/imorig(r,s+1,2) + u(4) * imorig(r+1,s,1)/imorig(r+1,s,2));
         u =[1 / (1 + abs(imorig(r-1,s,3) - imorig(r,s-1,3)) + abs(imorig(r-1,s,3) - imorig(r,s+1,3)) + abs(imorig(r-1,s,3) - imorig(r+1,s,3))), ...
             1 / (1 + abs(imorig(r,s-1,3) - imorig(r-1,s,3)) + abs(imorig(r,s-1,3) - imorig(r+1,s,3)) + abs(imorig(r,s-1,3) - imorig(r,s+1,3))), ...
             1 / (1 + abs(imorig(r,s+1,3) - imorig(r,s-1,3)) + abs(imorig(r,s+1,3) - imorig(r-1,s,3)) + abs(imorig(r,s+1,3) - imorig(r+1,s,3))), ...
             1 / (1 + abs(imorig(r+1,s,3) - imorig(r,s-1,3)) + abs(imorig(r+1,s,3) - imorig(r,s+1,3)) + abs(imorig(r+1,s,3) - imorig(r-1,s,3)))];
         u = u / sum(u);
         imorig(r,s,3) = imorig(r,s,2) * (u(1) * imorig(r-1,s,3)/imorig(r-1,s,2) + u(2) * imorig(r,s-1,3)/imorig(r,s-1,2) + u(3) * imorig(r,s+1,3)/imorig(r,s+1,2) + u(4) * imorig(r+1,s,3)/imorig(r+1,s,2));
      end
  end 
end

