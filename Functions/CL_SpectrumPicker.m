%% CL spectrum picker
%Michael Braun

global wavelength CLspectra_permuted cirpos circcolors colorindex ellipseHandle mask_single

circcolors={'cyan' 'red' 'green' 'blue' 'magenta' 'yellow' 'white' 'black'};
colorindex=1;
ROIpicker=figure;
ROIpicker_handle=gca;
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);
colormap gray
imagesc(SEM_SEdet)
pbaspect([1 1 1])
title('SEM Secondary Electron Image','Interpreter','latex')
axis off
savebtn = uicontrol('Style', 'pushbutton', 'String', 'Save',...
    'Units','normalized','Position', [0.1 0.55 0.125 0.075],...
    'Callback', @savefun);

exportbtn = uicontrol('Style', 'pushbutton', 'String', 'Export',...
    'Units','normalized','Position', [0.1 0.45 0.125 0.075],...
    'Callback', @exportfun);

%Plot initial spectrum area
ellipseHandle=imellipse(ROIpicker_handle, [ length(SEM_SEdet)/2 length(SEM_SEdet)/2 length(SEM_SEdet)/20 length(SEM_SEdet)/20 ] );
ellipseHandle.setFixedAspectRatioMode( '1' )
cirpos=ellipseHandle.getPosition;
mask_single=createMask(ellipseHandle);

kk=1;
spec_selected=zeros(nnz(mask_single),size(spec_data_corr,3));
for ii=1:size(mask_single,1)
    for jj=1:size(mask_single,2)
        if mask_single(ii,jj)==0
        else spec_selected(kk,:)=spec_data_corr(ii,jj,:).*(mask_single(ii,jj));
            kk=kk+1;
        end
    end
end
CLspectra=mean(spec_selected,1);
CLspectra_permuted=(permute(CLspectra,[2 1]));

%Converted to wavelength from pixel value, specific for 800 nm
%center wavelength, slightly different at other center wavelengths,
%take an identical spectrum in spectrometer software to compare!
wavelength=linspace(spec_center-277.03638,spec_center+279.2435,length(CLspectra));
CLspec_fig=figure();
CLspec_plot=plot(wavelength,CLspectra_permuted','k');
title('Frame Averaged Spectrum','Interpreter','latex')
xlabel('Wavelength (nm)','Interpreter','latex')
ylabel('Intensity','Interpreter','latex')
axis([min(wavelength) max(wavelength) -inf inf])
addNewPositionCallback(ellipseHandle,@(posit) CL_specdraw(posit,spec_data_corr,CLspec_plot));