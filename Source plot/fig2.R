library(ggplot2)
library(cowplot)

load("fig2.RData")

###          ###
### subfig_ab ###
###          ###
plot_p_ab <- function(df, y_label=FALSE, legend=FALSE, y_tick=TRUE, advice=FALSE) {
  x_pos = 1.35
  y_pos = if (advice) 78 else 90
  p <- ggplot(df, aes(x = catego, y = p, group = group))+
    geom_col(
      aes(fill = group, color = group),
      width = 0.45,
      position = position_dodge(width = 0.45),
      linewidth = 1.8
    )+
    labs(x = "", y = if (y_label) "Proportion (%)" else "") +
    scale_y_continuous(breaks = seq(0, 100, 20)) +
    scale_color_manual(values = c("ZheePal" = "#C72D94","Usual" = "#3E4A5C"),
                       labels = c("ZheePal        ", "Usual")) +
    scale_fill_manual(values = c("ZheePal" = "#E890C5","Usual"= "#BFC4CC"),
                      labels = c("ZheePal        ", "Usual")) +
    geom_segment(aes(x = x_pos, xend = x_pos+0.1, y = p[1], yend = p[1]), color = "#C7C4B1", linewidth = 1) +
    geom_segment(aes(x = x_pos, xend = x_pos+0.1, y = p[2], yend = p[2]), color = "#C7C4B1", linewidth = 1) +
    geom_segment(aes(x = x_pos+1, xend = x_pos+1.1, y = p[3], yend = p[3]), color = "#C7C4B1", linewidth = 1) +
    geom_segment(aes(x = x_pos+1, xend = x_pos+1.1, y = p[4], yend = p[4]), color = "#C7C4B1", linewidth = 1) +
    geom_segment(aes(y = p[1], yend = (p[1]+p[2])/2+5, x = x_pos+0.05, xend = x_pos+0.05), color = "#C7C4B1",linewidth=1)+
    geom_segment(aes(y = p[2], yend = (p[1]+p[2])/2-5, x = x_pos+0.05, xend = x_pos+0.05), color = "#C7C4B1",linewidth=1)+
    geom_segment(aes(y = p[3], yend = (p[3]+p[4])/2+5, x = x_pos+1.05, xend = x_pos+1.05), color = "#C7C4B1",linewidth=1)+
    geom_segment(aes(y = p[4], yend = (p[3]+p[4])/2-5, x = x_pos+1.05, xend = x_pos+1.05), color = "#C7C4B1",linewidth=1)+
    geom_segment(aes(y = y_pos-4, yend = y_pos-8, x = 1-0.45/2, xend = 1-0.45/2), color = "#C7C4B1",linewidth=1)+
    geom_segment(aes(y = y_pos-4, yend = y_pos-8, x = 1+0.45/2, xend = 1+0.45/2), color = "#C7C4B1",linewidth=1)+
    geom_segment(aes(y = y_pos-4, yend = y_pos-4, x = 1-0.45/2, xend = 1+0.45/2), color = "#C7C4B1",linewidth=1)+
    geom_segment(aes(y = y_pos-4, yend = y_pos-8, x = 2-0.45/2, xend = 2-0.45/2), color = "#C7C4B1",linewidth=1)+
    geom_segment(aes(y = y_pos-4, yend = y_pos-8, x = 2+0.45/2, xend = 2+0.45/2), color = "#C7C4B1",linewidth=1)+
    geom_segment(aes(y = y_pos-4, yend = y_pos-4, x = 2-0.45/2, xend = 2+0.45/2), color = "#C7C4B1",linewidth=1)+
    geom_segment(aes(y = -3, yend = -3, x = 1-0.45/2-0.05, xend = x_pos+1.1+0.05), color = "black",linewidth=0.5)+
    geom_segment(aes(y = -3, yend = -6, x = 1-0.45/2-0.05, xend = 1-0.45/2-0.05), color = "black",linewidth=0.5)+
    geom_segment(aes(y = -3, yend = -6, x = x_pos+1.1+0.05, xend = x_pos+1.1+0.05), color = "black",linewidth=0.5)+
    theme_minimal(base_size = 11) +
    theme(
      legend.title = element_blank(),
      legend.position = if (legend) "top" else "none",
      legend.text = element_text(size = 22),  
      legend.key.width  = unit(1.0, "cm"),    
      legend.key.height = unit(0.8, "cm"),   
      panel.grid = element_blank(),
      axis.text.x = element_text(size = 25, color = "black", margin = margin(t = 5)),
      axis.ticks.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.title.y = element_text(size = 27, color = "black", margin = margin(r = 35)),
      axis.title.x = element_blank(),
      plot.margin = margin(t = 35, r = 10, b = 5, l = 10),
      text = element_text(face = "plain"),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "transparent", colour = NA)
    ) +
    annotate("text",x = 1.5,y = if (advice) 97 else 107,label = df$time[1],size = 10,fontface = "plain") +
    annotate("text",x = 1,y = y_pos, label = paste0('aRR ', df$or[1]), size = 9,fontface = "plain")+
    annotate("text",x = 2,y = y_pos, label = paste0('aRR ', df$or[3]), size = 9,fontface = "plain")+
    annotate("text",x = x_pos+0.05,y = (df$p[1]+df$p[2])/2,label = paste0('PP ', df$pp[1]), size = 9,fontface = "plain")+
    annotate("text",x = x_pos+1.05,y = (df$p[3]+df$p[4])/2,label = paste0('PP ', df$pp[3]), size = 9,fontface = "plain")+
    coord_cartesian(ylim = c(0, 100),clip = "off")
  
  if (y_tick) {
    p <- p +
      geom_segment(
        aes(y = 0, yend = 100, x = 0.6, xend = 0.6),
        color = "black",
        linewidth = 0.5
      ) +
      geom_segment(
        data = data.frame(
          x = 0.6,
          xend = 0.55,
          y = seq(0, 100, 20),
          yend = seq(0, 100, 20)
        ),
        aes(x = x, xend = xend, y = y, yend = yend),
        color = "black",
        linewidth = 0.5,
        inherit.aes = FALSE
      )+
      annotate("text",x = 0.5,y = seq(0,100,20),label = seq(0,100,20),hjust = 1,size = 8)
  }
  
  
  if(legend){
    p <- p+
      geom_errorbar(
        aes(ymin = lower, ymax = upper),
        color = "black",
        width = 0.05,
        linewidth = 1,
        position = position_dodge(width = 0.45)
      )
    legend_all <- get_plot_component(p, "guide-box", return_all = TRUE)
    p <- ggdraw(legend_all[[4]])
  } else {
    p <- p+
      geom_errorbar(
        aes(ymin = lower, ymax = upper, color=group),
        width = 0.05,
        linewidth = 1,
        position = position_dodge(width = 0.45)
      )
  }
  
  return(p)
}

###          ###
### subfig_c ###
###          ###
plot_p_c <- function(df, y_label=FALSE, legend=FALSE, y_tick=TRUE) {
  x_pos = 1.35
  y_pos = 65
  p <- ggplot(df, aes(x = time, y = p, group = group))+
    geom_col(
      aes(fill = group, color = group),
      width = 0.45,
      position = position_dodge(width = 0.45),
      linewidth = 1.8
    )+
    labs(x = "", y = if (y_label) "Proportion (%)" else "") +
    scale_y_continuous(
      breaks = seq(0, 100, 20)
    ) +
    scale_color_manual(values = c("ZheePal" = "#ea801c","Usual" = "#3594cc"),
                       labels = c("ZheePal        ", "Usual")) +
    scale_fill_manual(values = c("ZheePal" = "#f9d9bb","Usual"= "#c2dff0"),
                      labels = c("ZheePal        ", "Usual")) +
    theme_minimal(base_size = 11) +
    theme(
      legend.title = element_blank(),
      legend.position = if (legend) "top" else "none",
      legend.text = element_text(size = 22),  
      
      legend.key.width  = unit(1.0, "cm"),    
      legend.key.height = unit(0.8, "cm"),   
      panel.grid = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      plot.margin = margin(t = 100, r = 210, b = 50, l = 20),
      text = element_text(face = "plain"),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "transparent", colour = NA),
    )+
    annotate("text",x = 1.68,y = 50,label = "Proportion (%)",size = 9.3,fontface = "plain") +
    annotate("text",x = 0.6,y = 50,label = df$time[1],size = 9,fontface = "plain") +
    coord_flip(clip = "off")
  
  if (y_tick) {
    p <- p +
      geom_segment(
        aes(y = 0, yend = 100, x = 1.35, xend = 1.35),
        color = "black",
        linewidth = 0.5
      ) +
      geom_segment(
        data = data.frame(
          x = 1.35,
          xend = 1.4,
          y = seq(0, 100, 20),
          yend = seq(0, 100, 20)
        ),
        aes(x = x, xend = xend, y = y, yend = yend),
        color = "black",
        linewidth = 0.5,
        inherit.aes = FALSE
      )+
      # annotate("text",x = 0.5,y = seq(0,100,20),label = seq(0,50,10),hjust = 1, size = 8)
      annotate("text",x = 1.52,y = seq(0,100,20),label = seq(0,50,10),hjust = 0.5, vjust = 1, size = 8)
  }
  
  
  if(legend){
    p <- p+
      geom_errorbar(
        aes(ymin = lower, ymax = upper),
        color = "black",
        width = 0.05,
        linewidth = 1,
        position = position_dodge(width = 0.45)
      )
    legend_all <- get_plot_component(p, "guide-box", return_all = TRUE)
    p <- ggdraw(legend_all[[4]])
  } else {
    p <- p+
      geom_errorbar(
        aes(ymin = lower, ymax = upper, color=group),
        width = 0.05,
        linewidth = 1,
        position = position_dodge(width = 0.45)
      )
  }
  
  return(p)
}

p_2_h <- plot_p_ab(two_df_he, y_label=TRUE)
p_2_a <- plot_p_ab(two_df_ad, y_label=TRUE, advice=TRUE)
p_4_h <- plot_p_ab(four_df_he, y_tick = FALSE)
p_4_a <- plot_p_ab(four_df_ad, y_tick = FALSE, advice=TRUE)
p_8_h <- plot_p_ab(eight_df_he, y_tick = FALSE)
p_8_a <- plot_p_ab(eight_df_ad, y_tick = FALSE, advice=TRUE)
p_cog <- plot_p_c(cog_df, y_label=TRUE)
p_an <- plot_p_c(an_df, y_label=TRUE)
p_de <- plot_p_c(de_df, y_label=TRUE)
p_lo <- plot_p_c(lo_df, y_label=TRUE)
p_legend_ab <- plot_p_ab(four_df_ad, legend=TRUE)
p_legendc <- plot_p_c(cog_df, legend=TRUE)
title_labela <- ggdraw() + draw_label("Help-seeking", angle = 0, x = 0.3, y = 0.55, size = 20, fontface = "plain")
title_labelb <- ggdraw() + draw_label("Advice adherence", angle = 0, x = 0.3, y = 0.55, size = 20, fontface = "plain")
title_labelc <- ggdraw() + draw_label("Screening positive at 8 months", angle = 0, x = 0.5, y = 0.55, size = 20, fontface = "plain")

ggsave("plot/fig2/legend_ab.pdf", plot = p_legend_ab, width = 8, height = 2, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/legend_c.pdf", plot = p_legendc, width = 8, height = 2, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/p_2_h.pdf", plot = p_2_h, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/p_2_a.pdf", plot = p_2_a, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/p_4_h.pdf", plot = p_4_h, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/p_4_a.pdf", plot = p_4_a, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/p_8_h.pdf", plot = p_8_h, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/p_8_a.pdf", plot = p_8_a, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/p_cog.pdf", plot = p_cog, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/p_an.pdf", plot = p_an, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/p_de.pdf", plot = p_de, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/p_lo.pdf", plot = p_lo, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/title_labela.pdf", plot = title_labela, width = 6, height = 1, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/title_labelb.pdf", plot = title_labelb, width = 6, height = 1, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig2/title_labelc.pdf", plot = title_labelc, width = 6, height = 1, device = cairo_pdf, family = "Aptos", bg = "transparent")
