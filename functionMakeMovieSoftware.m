function functionMakeMovieSoftware(handles)


v = VideoWriter([pwd '\OD Single Column Analysis']);
%v = VideoWriter('newfile1.avi');
v.FrameRate = 2 ;
v.Quality = 50;
open(v);
axis tight manual
set(gca,'nextplot','replacechildren');

Condition = handles.Condition; 

if Condition(1) == 1
    
    load('workspaceHumanfig3.mat');
    surrounding_exclude_scalebar = surrounding;
    %surrounding_exclude_scalebar(1056:1062,65:281) = 0;
    ODImage = input_bw.*v1_region*2 + surrounding_exclude_scalebar;
    
elseif Condition(2) == 1
    
    load('workspaceMacaque.mat');
    ODImage = input_bw.*v1_region*2 + surrounding;
    
elseif Condition(3) == 1
    
    load('workspaceCat.mat');
    ODImage = input_bw.*v1_region*2 + surrounding;
    
end




step_hist  = 30;
initial_edge = -(step_hist/2);
last_edge = 360 + initial_edge;
edge_range = (initial_edge:step_hist:last_edge);
bin_plot= (0:step_hist:360) *(pi/180);

[L_ipsi,N_region_ipsi] = bwlabel(~input_bw.*v1_region);%ipsi black
[L_contra,N_region_contra] = bwlabel(input_bw.*v1_region);%contra _ white


for i_ipsi  = 1:N_region_ipsi%1:10%
    
    selected_region = L_ipsi  == i_ipsi ;
    %figure,imshow(selected_region)
    
    if ( sum(sum(selected_region))>100 ) % to remove noises
        
            angle_line = output_orientation_ipsi{i_ipsi};
            thick = output_thickness_ipsi{i_ipsi};
        
            cla(handles.axesImage,'reset')
            axes(handles.axesImage);
            imagesc(ODImage)
            colormap([0 0 0;0.7 0.7 0.7;1 1 1])
            axis off
            %text(90, 1010,'10 mm','fontsize',20)
            title(sprintf('Ipsilateral Stripe %.0f, Length = %.0f pixels (%.2f mm)',i_ipsi,npoint_ipsi(i_ipsi),npoint_ipsi(i_ipsi)*pixel2um/1000),'fontsize',16)
            [selected_region_row,selected_region_col] = find(edge(selected_region));
            hold on, plot(selected_region_col,selected_region_row,'.r')
            
            cla(handles.axesResult)
            set(handles.axesResult,'visible','on')
            axes(handles.axesResult)
            thick(thick<0) = 0;
            [N_thick_ipsi,plot2] = hist_mid_line(thick,nbins_thickness_ipsi,'k');
            axis([.9*min(thick) 1.1*max(thick) -.05 1])
            xlabel('Stripe Width ','fontsize',14)
            ylabel('Frequency','fontsize',14)
            title(sprintf('                                       Mean Stripe Width = %.2f pixels (%.3f mm) \n ',thickness_ipsi(i_ipsi),thickness_ipsi(i_ipsi)*pixel2um/1000),'fontsize',16)
            ax_width = gca;
            get( ax_width );
            set( ax_width, 'Color', [0.7,0.7,0.7] )
            ax_width.TickDir = 'out';
            ax_width.TickLength = [0.02 0.02];
            box(ax_width,'off')
            
            axes(handles.axesOrientation)
            set(handles.axesOrientation,'visible','on')
            angle_line_0_180 = angle_line .* (angle_line>0) + (angle_line+180) .* (angle_line<0);
            angle_line_full_range_I = cat(2,angle_line_0_180,angle_line_0_180+180);
            [frequency_ipsi,bin_edge_ipsi] = histcounts(angle_line_full_range_I * (pi/180) ,edge_range * (pi/180),'Normalization','Probability'); %edge is the bar start and end points
            frequency_ipsi(1) = frequency_ipsi(floor(end/2)+1);% 0 and 180 should be equal
            frequency_ipsi(end+1) = frequency_ipsi(1); %    for smooth plotting
            polar_histogram_predefined_edge_makevideo(bin_plot,frequency_ipsi,max(frequency_ipsi),'-',[0 0 0]/255);
            xlabel('Stripe Angle','fontsize',14)
            
            %{
            if save_single_column == 1
                name_output_result1 = [save_direction 'ipsi' num2str(i_ipsi) '.jpg'];
                saveas(figure(1),name_output_result1)
                
                name_output_result2 = [save_direction 'ipsi' num2str(i_ipsi) '.fig'];
                saveas(figure(1),name_output_result2)
                close all
            end
            %}
            
            %pic_name = myFiles(sorted_ind_ipsi(k)).name ;
            %openfig([dir '\' pic_name]);
            frame = getframe(gcf);
            %frameTemp = frame.cdata; 
            %frame.cdata = frameTemp(1:770,380:1025,:);  %  figure,imshow(frame.cdata)
            writeVideo(v,frame);
            %close all
            
            pause(.1)
    end

end




for i_contra = 1:N_region_contra%%6
    
    selected_region = L_contra == i_contra;
    %figure,imshow(selected_region)
    
    if ( sum(sum(selected_region))>100 ) % to remove noises
        
            angle_line = output_orientation_contra{i_contra};
            thick = output_thickness_contra{i_contra};
            
            cla(handles.axesImage,'reset')
            axes(handles.axesImage);
            imagesc(ODImage)
            colormap([0 0 0;0.7 0.7 0.7;1 1 1])
            axis off
            %text(90, 1010,'10 mm','fontsize',20)
            title(sprintf('Contralateral Stripe %.0f, Length = %.0f pixels (%.2f mm)',i_contra,npoint_contra(i_contra),npoint_contra(i_contra)*pixel2um/1000),'fontsize',16)
            [selected_region_row,selected_region_col] = find(edge(selected_region));
            hold on, plot(selected_region_col,selected_region_row,'.r')
            
            cla(handles.axesResult)
            set(handles.axesResult,'visible','on')
            axes(handles.axesResult);
            thick(thick<0) = 0;
            [N_thick_contra,plot2] = hist_mid_line(thick,nbins_thickness_contra,'w');
            axis([.9*min(thick) 1.1*max(thick) -.05 1])
            %axis([.9*min(thick) 1.1*max(thick) -.05 1.1*max(N_thick_contra)])
            xlabel('Stripe Width ','fontsize',14)
            ylabel('Frequency','fontsize',14)
            title(sprintf('                                       Mean Stripe Width = %.2f pixels (%.3f mm) \n ',thickness_contra(i_contra),thickness_contra(i_contra)*pixel2um/1000),'fontsize',16)
            ax_width = gca;
            get( ax_width );
            set( ax_width, 'Color', [0.7,0.7,0.7] )
            %set(ax_width, 'Color', 'none');
            ax_width.TickDir = 'out';
            %ax_width.TickLength = [0.03 0.025]; %  The General Values that are used for paper
            ax_width.TickLength = [0.02 0.02];
            box(ax_width,'off')
            
            cla(handles.axesOrientation)
            set(handles.axesOrientation,'visible','on')
            axes(handles.axesOrientation);
            angle_line_0_180 = angle_line .* (angle_line>0) + (angle_line+180) .* (angle_line<0);
            angle_line_full_range_C = cat(2,angle_line_0_180,angle_line_0_180+180);
            [frequency_contra,bin_edge_contra] = histcounts(angle_line_full_range_C * (pi/180) ,edge_range * (pi/180),'Normalization','Probability'); %edge is the bar start and end points
            frequency_contra(1) = frequency_contra(floor(end/2)+1);% 0 and 180 should be equal
            frequency_contra(end+1) = frequency_contra(1); %    for smooth plotting
            polar_histogram_predefined_edge_makevideo(bin_plot,frequency_contra,max(frequency_contra),'-',[1 1 1]);
            xlabel('Stripe Angle','fontsize',14)
            

            frame = getframe(gcf);
            %frameTemp = frame.cdata; 
            %frame.cdata = frameTemp(1:770,380:1025,:);  %  figure,imshow(frame.cdata)
            writeVideo(v,frame);
             
             pause(.1)
    end
    
end

    

close(v);






