function [  ] = LaTeXifyTicks( fontSize, Vscale, Hscale, Xlabel, Ylabel )
%LATEXIFYTICKS Summary of this function goes here
%   Detailed explanation goes here
    title('');
    set(get(gca,'XLabel'),'String',[])
    set(get(gca,'YLabel'),'String',[])
    set(gca,'yticklabel',[], 'xticklabel', [])
    yTicks = get(gca,'ytick');
    xTicks = get(gca,'xtick');
    ax = axis;

    verticalOffset = fontSize / Vscale;
    for i = 1:length(xTicks)
        text(xTicks(i), ax(3) - verticalOffset, ['$' num2str( xTicks(i)) '$'],'HorizontalAlignment','Center','interpreter', 'latex','FontSize', fontSize); 
    end
    text((ax(1)+ax(2))/2, ax(3) - verticalOffset*2.5,   Xlabel, 'HorizontalAlignment','Center','interpreter', 'latex','FontSize', fontSize); 

    horizontalOffset = fontSize / Hscale;
    L = size(num2str(yTicks(:)),2);
    for i = 1:length(yTicks) 
        text(ax(1) - horizontalOffset,yTicks(i),['$' num2str(yTicks(i)) '$'],'HorizontalAlignment','Right','interpreter', 'latex','FontSize', fontSize); 
    end
    text(ax(1) - horizontalOffset*(L+2.5), (ax(3)+ax(4))/2, Ylabel, 'HorizontalAlignment','Right', 'interpreter', 'latex','FontSize', fontSize); 
end
