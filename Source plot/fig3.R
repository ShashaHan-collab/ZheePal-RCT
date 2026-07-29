library(ggplot2)
library(cowplot)
library(ggbeeswarm)
library(dplyr)

load("fig3.RData")

###          ###
### subfig_a ###
###          ###
bar_a<-function(D, x_label=FALSE, legend=FALSE, y_label=FALSE){
  level_x <- c(
    "Low" = 1,
    "Moderately\nlow" = 4,
    "Moderate" = 7,
    "Moderately\nhigh" = 10,
    "High" = 13
  )
  
  D$xpos <- level_x[D$Level]
  size=0.5
  xlabel<-unique(D$Dimension)
  p <- ggplot(D, aes(x = xpos, y = No., fill = Group, color = Group)) +
    geom_col(width = 2.5,
             position = position_dodge(width = 2.67),
             linewidth = 1.8) +
    labs(
      x = xlabel, y = if (y_label) "Number of participants" else "", fill = "Group",
      title = ""
    ) +
    scale_fill_manual(values = c("Zhiban" = "#F0B5D6","Usual"= "#D1D5DB"), labels = c("ZheePal    ", "Usual")) +
    scale_color_manual(
      values = c("Zhiban" = "#C72D94",
                 "Usual"   = "#3E4A5C"), labels = c("ZheePal    ", "Usual")
    ) +
    scale_y_continuous(breaks = (c(0, 300, 600, 900))) +
    coord_cartesian(
      ylim = c(0, 900),
      clip = "off"
    )+
    scale_x_continuous(
      breaks = level_x,
      labels = names(level_x)
    )+
    geom_segment(aes(x =1, xend = 13, y = -Inf, yend = -Inf), color = "black",linewidth=0.1) +
    geom_segment(aes(y = 0, yend = 900, x = -0.7, xend = -0.7), color = "black",linewidth=0.1)+
    geom_segment(data = data.frame(
      x = -0.7, xend = -0.9,
      y = seq(0, 900, 300),
      yend = seq(0, 900, 300)),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.6, inherit.aes = FALSE
    )+
    theme_minimal()+
    theme(
      legend.title = element_blank(),
      legend.position = if (legend) "top" else "none",
      legend.text = element_text(size = 22),  
      legend.key.width  = unit(1.0, "cm"),    
      legend.key.height = unit(0.8, "cm"),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text.x = if (x_label) element_text(size = 25, color = "black", vjust = 0.5) else element_blank(),
      axis.ticks.x = element_line(color = "black", linewidth=size), 
      axis.ticks.length.x = unit(10, "pt"),
      axis.title.x = element_blank(),
      text = element_text(face = "plain"),
      axis.text.y = element_text(size = 30, color = "black", margin = margin(r=-15)),
      axis.ticks.y = element_blank(), 
      axis.title.y = element_text(size = 24, color = "black",margin = margin(r=12)),
      plot.margin = if (y_label) margin(t = 0, r = 5, b = 10, l = 5) else margin(t = 0, r = 5, b = 5, l = -30)
    )+
    annotate("text", x = 10-1.25, y = 800, label = xlabel,size = 10.5, hjust = 0)+
    annotate("text", x = 10, y = 450, label = "P < 0.001",size = 9.8)
  
  if(legend){
    legend_all <- get_plot_component(p, "guide-box", return_all = TRUE)
    p <- ggdraw(legend_all[[4]])
  }
  
  return(p)
}

ap_cog<-bar_a(A_cog)
ap_an<-bar_a(A_an)
ap_de<-bar_a(A_de)
ap_lo<-bar_a(A_lo, x_label = TRUE)
ab_label_w <- ggdraw() + draw_label("   ", size = 28, x = 0.45, y = -0.5, hjust = 0, vjust = 0)
ap<-plot_grid(ap_cog,ap_an,ap_de,ap_lo, ncol=1,rel_heights = c(1,1,1,1.2))
ap <- plot_grid(ab_label_w , ap, nrow = 1,rel_widths = c(0.01, 1))
ay_lab <- ggdraw() + draw_label("Number of participants", y = 0.52, x=0.3,angle = 90, size = 31)
ap <- plot_grid(ay_lab,ap,ncol = 2,rel_widths = c(0.1, 1))
ap_label <- bar_a(A_cog, legend = TRUE)


###          ###
### subfig_b ###
###          ###
plot_b <- function(df_long, dim_name, show_x = FALSE, show_y = FALSE, show_legend = FALSE) {
  p <- ggplot(df_long, aes(x = ZheePal, y = Sel_report, fill = agreement)) +
    geom_tile() +
    geom_text(aes(label = Count), color = "black", size = 11) +
    scale_fill_manual(
      values = c(
        "agreement"    = "#c99b38",   # Med brown
        "disagreement" = "#eddca5"    # Light brown
      ),
      labels = c(
        "agreement"    = "Agreement    ",
        "disagreement" = "Disagreement"
      ),
      guide = if (show_legend)
        guide_legend(
          title = NULL,
          keyheight = 1.2,
          keywidth  = 1.2,
          label.theme = element_text(size = 13)
        )
      else "none"
    ) +
    labs(title = dim_name,
         x = if(show_x) "ZheePal" else NULL,
         y = if(show_y) "Self-perception" else NULL) +
    theme_minimal() +
    theme(
      legend.position = if (show_legend) "top" else "none",
      plot.title = element_text(hjust = 0.5, size = 43),
      axis.text.x = if(show_x) element_text(size = 37, color = "black", hjust = 1, vjust = 0.5,  angle = 90) else element_blank(),
      axis.text.y = if(show_y) element_text(size = 37, color = "black", hjust = 1) else element_blank(),
      axis.ticks =element_line(color = "black"),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.grid = element_blank(),
      text = element_text(face = "plain"),
      plot.margin = if (show_y) margin(t = 5, r = -5, b = 0, l = 5) else margin(t = 5, r = 0, b = 0, l = 0)
    )
  
  
  if(show_legend){
    p <- p +
      guides(
        fill = guide_legend(
          label.theme = element_text(size = 16),
          title = NULL
        )
      )
    legend_all <- get_plot_component(p, "guide-box", return_all = TRUE)
    legend_only <- ggdraw(legend_all[[4]])
    return(legend_only)
  } else {
    return(p)   
  }
}

bp_an <- plot_b(B_p_an, "Anxiety")
bp_de <- plot_b(B_p_de, "Depression", show_x = TRUE, show_y = TRUE)
bp_lo <- plot_b(B_p_lo, "Loneliness", show_x = TRUE)
bp_cog <- plot_b(B_p_cog, "Cognitive decline", show_y = TRUE)
bp_legend <- plot_b(B_p_cog, "Cognitive decline", show_legend = TRUE)
bp<-plot_grid(bp_cog,bp_an,nrow=1,rel_widths = c(1.4, 1))
bp1<-plot_grid(bp_de,bp_lo,nrow=1,rel_widths = c(1.4, 1))
bb_label_w <- ggdraw() + draw_label("   ", size = 28, x = 0.45, y = -0.5, hjust = 0, vjust = 0)
bp<-plot_grid(bp,bp1,ncol=1,rel_heights = c(1,1.4))
by_lab <- ggdraw() + draw_label("Self-perception", y = 0.54, x =0.2 , angle = 90, size = 45)
bp <- plot_grid(by_lab,bp,ncol = 2,rel_widths = c(0.08, 1))
bx_lab <- ggdraw() +draw_label("ZheePal",x = 0.6,size = 45,fontface = "plain")
bp <- plot_grid(bp,bb_label_w, bx_lab,ncol = 1,rel_heights = c(1,0.03, 0.05))


###          ###
### subfig_c ###
###          ###
plot_c <- function(df, legend=TRUE){
  df$group <- factor(
    df$group,
    levels = c("ZheePal", "Usual")  
  )
  p <- ggplot(
    df,
    aes(x = Dimension, y = mean, group = group)
  ) +
    geom_errorbar(
      aes(
        ymin = mean - sd,
        ymax = mean + sd,
        color = group
      ),
      width = 0.08,
      linewidth = 1.5,
      position = position_dodge(width = 0.6)
    ) +
    geom_point(
      aes(color = group),
      size = 12,
      position = position_dodge(width = 0.6)
    ) +
    scale_color_manual(
      values = c("ZheePal" = "#C72D94",
                 "Usual"   = "#3E4A5C"), labels = c("ZheePal    ", "Usual")
    ) +
    scale_x_discrete(
      labels = c(
        "Cognitive\ndecline",
        "Mental\nhealth"
      )
    )+
    annotate("segment", x = 0.3, xend = 0.3, y = 1, yend = 5, color = "black", linewidth = 0.7) +
    annotate("segment", x = 0.6, xend = 1.4, y = 0.8, yend = 0.8, color = "black", linewidth = 0.7) +
    annotate("segment", x = 1.6, xend = 2.4, y = 0.8, yend = 0.8, color = "black", linewidth = 0.7) +
    geom_segment(data = data.frame(
      x = 0.3, xend = 0.26,
      y = seq(1, 5, 1),
      yend = seq(1, 5, 1)),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.7, inherit.aes = FALSE
    )+
    annotate("segment", x = 0.6, xend = 0.6, y = 0.8, yend = 0.6, color = "black", linewidth = 0.7)+
    annotate("segment", x = 1.4, xend = 1.4, y = 0.8, yend = 0.6, color = "black", linewidth = 0.7) +
    annotate("segment", x = 1.6, xend = 1.6, y = 0.8, yend = 0.6, color = "black", linewidth = 0.7)+
    annotate("segment", x = 2.4, xend = 2.4, y = 0.8, yend = 0.6, color = "black", linewidth = 0.7) +
    scale_y_continuous(
      breaks = 1:5
    ) +
    coord_cartesian(
      ylim = c(1, 5),
      clip = "off"
    )+
    labs(
      x = NULL,
      y = NULL
    ) +
    guides(
      color = guide_legend(
        override.aes = list(
          size = 5,        
          linewidth = 1.2  
        )
      )
    )+
    theme_minimal()+
    theme(
      axis.ticks.x = element_blank(),
      axis.ticks.y = element_blank(),
      axis.line = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text.y = element_text(size = 39.5, color = "black", margin = margin(r= 23)),
      axis.text.x = element_text(size = 35, color = "black", margin = margin(t= 20)),
      legend.position = if (legend) "top" else "none",
      legend.title = element_blank(),    
      legend.text = element_text(size = 22),
      legend.key.width = unit(1.8, "cm"),
      plot.margin = margin(t = 0, r = 0, b = 0, l = 30)
    )
  if(legend){
    legend_all <- get_plot_component(p, "guide-box", return_all = TRUE)
    p <- ggdraw(legend_all[[4]])
  }
  
  return(p)
}
cp_legend <- plot_c(C_df)
cb_label_w <- ggdraw() + draw_label("   ", size = 28, x = 0.45, y = -0.5, hjust = 0, vjust = 0)
cy_lab <- ggdraw() + draw_label("Likert scale\nof score", y = 0.62, x =0.2 , angle = 90, size = 41)
cp <- plot_c(C_df, legend = FALSE)
cp <- plot_grid(cb_label_w, cy_lab,cb_label_w,cp,ncol = 4,rel_widths = c(0.1, 0.08, 0.04, 1))


###          ###
### subfig_d ###
###          ###
geom_boxplot_pub <- function(
    data,
    mapping,
    box_linewidth = 1.8,
    whisker_linewidth = 0.6,
    median_fatten = 0.5,
    width = 0.6,
    coef = 0,
    color = "#00b0be",
    staplewidth = 0.2,
    ...
) {
  
  x_var <- rlang::as_name(mapping$x)
  y_var <- rlang::as_name(mapping$y)
  half_staple <- staplewidth / 2
  
  whisker_df <- data %>%
    group_by(.data[[x_var]]) %>%
    summarise(
      q1 = quantile(.data[[y_var]], 0.25, na.rm = TRUE),
      q3 = quantile(.data[[y_var]], 0.75, na.rm = TRUE),
      iqr = q3 - q1,
      lower = q1 - 1.5 * iqr,
      upper = q3 + 1.5 * iqr,
      ymin = min(.data[[y_var]][.data[[y_var]] >= lower], na.rm = TRUE),
      ymax = max(.data[[y_var]][.data[[y_var]] <= upper], na.rm = TRUE),
      .groups = "drop"
    )
  
  list(
    geom_boxplot(
      data = data,
      mapping = mapping,
      width = width,
      coef = 0,
      fill = NA,
      color = color,
      outlier.shape = NA,
      staplewidth = 0.35,
      linewidth = box_linewidth,
      fatten = median_fatten,
      ...
    ),
    
    geom_segment(
      data = whisker_df,
      aes(
        x = .data[[x_var]],
        xend = .data[[x_var]],
        y = q3,
        yend = ymax
      ),
      inherit.aes = FALSE,
      linewidth = whisker_linewidth,
      color = color
    ),
    
    geom_segment(
      data = whisker_df,
      aes(
        x = .data[[x_var]],
        xend = .data[[x_var]],
        y = q1,
        yend = ymin
      ),
      inherit.aes = FALSE,
      linewidth = whisker_linewidth,
      color = color
    ),
    geom_segment(
      data = whisker_df,
      aes(
        x = as.numeric(.data[[x_var]]) - half_staple,
        xend = as.numeric(.data[[x_var]]) + half_staple,
        y = ymax,
        yend = ymax
      ),
      inherit.aes = FALSE,
      linewidth = whisker_linewidth,
      color = color
    ),
    geom_segment(
      data = whisker_df,
      aes(
        x = as.numeric(.data[[x_var]]) - half_staple,
        xend = as.numeric(.data[[x_var]]) + half_staple,
        y = ymin,
        yend = ymin
      ),
      inherit.aes = FALSE,
      linewidth = whisker_linewidth,
      color = color
    )
  )
}



plot_p <- function(df, y_scale, x_label=FALSE) {
  y1 = y_scale$lim[1]
  y2 = y_scale$lim[2]
  y_pos = if (df$Dem[1]=="Loneliness") c((1/21)*18, (2.2/21)*18) else c((1/21)*y2, (2.2/21)*y2)
  p <- ggplot(df, aes(x = le_en, y = sc)) +
    geom_quasirandom(
      width = 0.18,
      alpha = 1,
      shape = 21,          
      fill = "grey95",     
      color = "grey70",    
      stroke = 1,
      size = 5
    )+
    geom_boxplot_pub(
      data = df,
      mapping = aes(x = le_en, y = sc),
      box_linewidth = 1.8,
      whisker_linewidth = 1,
      median_fatten = 1.0,
      color = "#00b0be",
      
    ) +
    scale_y_continuous(breaks = y_scale$breaks) +
    coord_cartesian(ylim = y_scale$lim,clip = "off")+
    geom_segment(
      data = data.frame(x = 0.4, xend = 0.4, y = y1, yend = y2),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.5
    )+
    geom_segment(data = data.frame(
      x = 0.4, xend = 0.32,
      y = seq(y1, y2, y_scale$n_ticks),
      yend = seq(y1, y2, y_scale$n_ticks)),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.5, inherit.aes = FALSE
    )+
    geom_segment(
      data = data.frame(x = 1, xend = 5, y = y1-y_pos[1], yend = y1-y_pos[1]),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.5
    )+
    geom_segment(
      data = data.frame(x = 1, xend = 1, y = y1-y_pos[1], yend = y1-y_pos[2]),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.5
    )+
    geom_segment(
      data = data.frame(x = 2, xend = 2, y = y1-y_pos[1], yend = y1-y_pos[2]),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.5
    )+
    geom_segment(
      data = data.frame(x = 3, xend = 3, y = y1-y_pos[1], yend = y1-y_pos[2]),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.5
    )+
    geom_segment(
      data = data.frame(x = 4, xend = 4, y = y1-y_pos[1], yend = y1-y_pos[2]),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.5
    )+
    geom_segment(
      data = data.frame(x = 5, xend = 5, y = y1-y_pos[1], yend = y1-y_pos[2]),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.5
    )+
    labs(title = df$Dem[1]) +
    theme_minimal() +
    theme(
      axis.text.x = if (x_label) element_text(size = 23, color = "black", vjust = 0.5,margin = margin(t = 10)) else element_blank(), 
      plot.title = element_text(hjust = 0, size = 27.5, vjust=2.5),
      axis.text.y = element_text(size = 28, color = "black", margin = margin(r = 20)),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.ticks.x = element_blank(),
      axis.ticks.y = element_blank()
    )
  
  return (p)
}

dp_cog<-plot_p(D_cog, D_y_config$cog)
dp_an<-plot_p(D_an, D_y_config$an)
dp_de<-plot_p(D_de, D_y_config$de, x_label=TRUE)
dp_lo<-plot_p(D_lo, D_y_config$lo, x_label=TRUE)
db_label_w <- ggdraw() + draw_label("   ", size = 28, x = 0.45, y = -0.5, hjust = 0, vjust = 0)
dp1<-plot_grid(dp_cog,dp_an, nrow=1,rel_widths = c(1, 1))
dp<-plot_grid(dp_de, dp_lo, nrow=1,rel_widths = c(1, 1))
dp<-plot_grid(db_label_w, dp1, db_label_w, dp, ncol=1,rel_heights = c(0.01,1, 0.25, 1.2))
dy_lab <- ggdraw() + draw_label("Scale score", y = 0.50,x=0.2, angle = 90, size = 30)
dp <- plot_grid(dy_lab,dp,ncol = 2,rel_widths = c(0.05, 1))
dx_lab <- ggdraw() +draw_label("ZheePal",x = 0.52,size = 28,fontface = "plain")
dp <- plot_grid(dp,db_label_w,dx_lab,ncol = 1,rel_heights = c(1, 0.03, 0.05))
dp <- dp + theme(plot.margin = margin(t = 5, l = 0, b = 0, r = 0))


###          ###
### subfig_e ###
###          ###
ep <- ggplot(E_df_long, aes(x = Dimension, y = kappa, group = type)) +
  geom_line(
    aes(color = type),
    linetype = "dashed",
    linewidth = 1.2
  ) +
  geom_point(
    aes(shape = type, color = type),
    size = 11
  ) +
  scale_shape_manual(
    values = c(15, 15),
    labels = c("ZheePal       ", "Instrument")
  ) +
  scale_color_manual(
    values = c("#C72D94", "#3E4A5C"),
    labels = c("ZheePal       ", "Instrument")
  ) +
  guides(
    color = guide_legend(
      override.aes = list(
        linetype = "dashed",  
        shape = c(15, 15),    
        size = 3
      )
    )
  )  +
  scale_y_continuous(breaks = seq(0.2, 1.0, 0.2))+
  coord_cartesian(ylim = c(0.2, 1.0)) +
  labs(
    x = NULL,
    y = "Weighted kappa",
    color = "Kappa type",
    shape = "Kappa type"
  )+
  annotate("segment", x = 0.7, xend = 0.7, y = 0.20, yend = 1.0, color = "black", linewidth = 0.6) +
  annotate("segment", x = 0.7, xend = 4 + 0.3, y = 0.20, yend = 0.20, color = "black", linewidth = 0.6) +
  annotate("segment", x = 4.3, xend = 4.3, y = 0.20, yend = 1.0, color = "black", linewidth = 0.6) +
  annotate("segment", x = 0.7, xend = 4 + 0.3, y = 1.0, yend = 1.0, color = "black", linewidth = 0.6) +
  geom_segment(data = data.frame(
    x = 0.7, xend = 0.6,
    y = seq(0.2, 1.0, 0.2),
    yend = seq(0.2, 1.0, 0.2)),
    aes(x = x, xend = xend, y = y, yend = yend),
    color = "black", linewidth = 0.7, inherit.aes = FALSE
  )+
  geom_segment(data = data.frame(
    y = 0.20, yend = 0.16,
    x = seq(1, 4, 1),
    xend = seq(1, 4, 1)),
    aes(x = x, xend = xend, y = y, yend = yend),
    color = "black", linewidth = 0.7, inherit.aes = FALSE
  )+
  guides(
    color = guide_legend(
      override.aes = list(
        size = 6,        
        linewidth = 0   
      )
    )
  )+
  theme_minimal()+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.line = element_blank(),
    axis.text.y = element_text(size = 35, color = "black", margin = margin(r= -5)),
    axis.text.x = element_text(size = 30, color = "black", margin = margin(t= 5), vjust=0.5),
    legend.position = "top",           
    legend.title = element_blank(),    
    legend.text = element_text(size = 27),
    legend.key.width  = unit(0, "cm"),
    axis.title.y = element_text(size = 34, color = "black",margin = margin(r=35)),
    legend.margin = margin(t = 0, b = 20)
  )


###          ###
### subfig_f ###
###          ###
fp <- ggplot(F_df, aes(x = Reason, y = Proportion)) +
  geom_col(width = 0.82, fill = "#FAD8EC") +
  scale_y_continuous(
    breaks = seq(0, 100, 25),
    labels = function(x) paste0(x, "")
  ) +
  coord_flip(ylim = c(0, 100),clip = "off")+
  labs(
    x = NULL,
    y = "Proportion (%)"
  )  +
  geom_segment(y = 0, yend = 100, x = 0.3, xend = 0.3, color = "black",linewidth=0.3)+
  geom_segment(data = data.frame(
    x = 0.3, xend = 0.2,
    y = seq(0, 100, 25),
    yend = seq(0, 100, 25)),
    aes(x = x, xend = xend, y = y, yend = yend),
    color = "black", linewidth = 0.5, inherit.aes = FALSE
  )+
  geom_segment(x = 0.5, xend = 5.5, y = -3, yend = -3, color = "black", linewidth = 0.3) +
  geom_segment(x = 0.5, xend = 0.5, y = -3, yend = -1.5, color = "black", linewidth = 0.3) +
  geom_segment(x = 5.5, xend = 5.5, y = -3, yend = -1.5, color = "black", linewidth = 0.3) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 28, color = "black", margin = margin(t = 10),),
    axis.text.y = element_text(size = 28, color = "black", margin = margin(r = -485), hjust = 0),
    legend.position = "none",
    panel.grid = element_blank(),
    axis.ticks.y = element_blank(),
    axis.title.y = element_blank(),
    axis.title.x = element_text(size = 28, color = "black",margin = margin(t=25)),
    axis.ticks.x = element_blank(),
    plot.margin = margin(r = 50, t=80, l = 80, b = 15)
  )


ggsave("plot/fig3/fig3a.pdf", plot = ap, width = 12, height = 11, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig3/legenda.pdf", plot = ap_label, width = 12, height = 1, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig3/fig3b.pdf", plot = bp, width = 16, height = 16, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig3/legendb.pdf", plot = bp_legend, width = 6, height = 1, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig3/legendc.pdf", plot = cp_legend, width = 6, height = 2, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig3/fig3c.pdf", plot = cp, width = 12, height = 7, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig3/fig3d.pdf", plot = dp, width = 21, height = 10, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig3/fig3e.pdf", plot = ep, width = 11, height = 10, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig3/fig3f.pdf", plot = fp, width = 10, height = 8, device = cairo_pdf, family = "Aptos", bg = "transparent")

