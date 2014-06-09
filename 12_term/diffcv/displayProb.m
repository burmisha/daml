function grafik = displayProb(Beta, Mu, p)
    % see http://www.matthiaspospiech.de/blog/2011/06/01/pcolor-plots-with-publication-ready-formating/
    grafik = pcolor(Beta, Mu, p);
    colorbar;
    set(grafik, 'EdgeColor', 'none')
    grid('off');
    axis('square'); 
    axis('ij');
    caxis([min(min(p)) max(max(p))]);
    hXLabel = xlabel('\beta');
    hYLabel = ylabel('\mu');
    hcb = colorbar('location','EastOutside');
    set([gca, hcb, hXLabel, hYLabel], 'FontSize', 16);
end



