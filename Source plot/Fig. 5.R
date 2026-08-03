library(ggplot2)
library(cowplot)
library(ggpattern)


load("fig5.RData")

###             ###
### panel_b_main ###
###             ###
plot_main <- function(df, y_label=FALSE, legend=FALSE, y_tick=TRUE) {
  x_pos = c(0.97, 0.165, 0.33, 1.005, 1.15, 1.33)
  x_delt = 0.03
  y_pos = 90
  y_delt = c(12, 0, -16)
  p <- ggplot(df, aes(x = catego, y = p, group = group))+
    geom_col(
      aes(fill = group, color = group),
      width = 0.65,
      position = position_dodge(width = 0.65),
      linewidth = 1.8
    )+
    labs(x = "", y = if (y_label) "Proportion (%)" else "") +
    scale_y_continuous(
      breaks = seq(0, 100, 20)
    ) +
    scale_color_manual(values = c("ZheePal" = "#C72D94","No diagnosis" = "#3E4A1A","No guidance" = "#3E4A8B","No logic" = "#393a3d"),
                       labels = c("ZheePal        ", "No diagnosis        ", "No guidance        ", "No logic")) +
    scale_fill_manual(values = c("ZheePal" = "#E890C5","No diagnosis" = "#c5c9ba","No guidance" = "#c5c9dc","No logic" = "#ecedef"),
                      labels = c("ZheePal        ", "No diagnosis        ", "No guidance        ", "No logic")) +
    geom_segment(aes(x = 1.29, xend = 1.29, y = p[4]+3, yend = 34), color = "black", linewidth = 0.5) +
    geom_segment(aes(x = 2.29, xend = 2.29, y = p[8]+3, yend = 34), color = "black", linewidth = 0.5) +
    geom_segment(aes(y = -3, yend = -3, x = 1-0.45/2-0.15, xend = x_pos[1]+1.1+0.35), color = "black",linewidth=0.5)+
    geom_segment(aes(y = -3, yend = -6, x = 1-0.45/2-0.15, xend = 1-0.45/2-0.15), color = "black",linewidth=0.5)+
    geom_segment(aes(y = -3, yend = -6, x = x_pos[1]+1.1+0.35, xend = x_pos[1]+1.1+0.35), color = "black",linewidth=0.5)+
    theme_minimal(base_size = 11) +
    theme(
      legend.title = element_blank(),
      legend.position = if (legend) "top" else "none",
      legend.text = element_text(size = 22),

      legend.key.width  = unit(1.4, "cm"),
      legend.key.height = unit(1.1, "cm"),
      panel.grid = element_blank(),
      axis.text.x = element_text(size = 26, color = "black", margin = margin(t = 5)),
      axis.ticks.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.title.y = element_text(size = 27, color = "black", margin = margin(r = 35)),
      axis.title.x = element_blank(),
      plot.margin = if (y_label) margin(t = 35, r = 3, b = 5, l = 5) else margin(t = 35, r = 20, b = 5, l = 5),
      text = element_text(face = "plain"),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "transparent", colour = NA)
    ) +
    annotate("text",x = 0.45,y = seq(0,100,20),label = seq(0,100,20),hjust = 1,size = 9)+
    annotate("text",x = 1.5,y = 107,label = df$behcat[1],size = 10,fontface = "plain") +
    coord_cartesian(ylim = c(0, 100),clip = "off")

  if (y_tick) {
    p <- p +
      geom_segment(
        aes(y = 0, yend = 100, x = 0.55, xend = 0.55),
        color = "black",
        linewidth = 0.5
      ) +
      geom_segment(
        data = data.frame(
          x = 0.55,
          xend = 0.5,
          y = seq(0, 100, 20),
          yend = seq(0, 100, 20)
        ),
        aes(x = x, xend = xend, y = y, yend = yend),
        color = "black",
        linewidth = 0.5,
        inherit.aes = FALSE
      )
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
        position = position_dodge(width = 0.65)
      )
  }

  return(p)
}

p_main_h <- plot_main(df_he, y_label=TRUE)
p_main_a <- plot_main(df_ad, y_label=TRUE)
p_legend1 <- plot_main(df_ad, legend=TRUE)


###            ###
### panel_b_sub ###
###            ###
plot_sub <- function(df, y_label=FALSE, legend=FALSE, y_tick=TRUE) {
  x_pos = 1.35
  y_pos = 90
  p <- ggplot(df, aes(x = catego, y = p, group = group))+
    geom_col_pattern(
      aes(
        fill = group,
        color = group,
        pattern = group
      ),
      width = 0.45,
      position = position_dodge(width = 0.45),
      linewidth = 1.8,
      pattern_density = 0.15,
      pattern_spacing = 0.03,
      pattern_angle = 45
    ) +
    scale_pattern_manual(
      values = c(
        "Time controlled" = "stripe",
        "Free conversation" = "circle"
      )
    )+
    labs(x = "", y = if (y_label) "Proportion (%)" else "") +
    scale_y_continuous(
      breaks = seq(0,40,20)
    ) +
    scale_color_manual(values = c("Time controlled" = "#393a3d","Free conversation" = "#393a3d"),
                       labels = c("Time controlled        ", "Free conversation")) +
    scale_fill_manual(values = c("Time controlled" = "#ecedef","Free conversation"= "#ecedef"),
                      labels = c("Time controlled        ", "Free conversation")) +
    geom_segment(aes(y = -3, yend = -3, x = 1-0.45/2-0.05, xend = x_pos-0.075), color = "black",linewidth=0.5)+
    geom_segment(aes(y = -3, yend = 0, x = 1-0.45/2-0.05, xend = 1-0.45/2-0.05), color = "black",linewidth=0.5)+
    geom_segment(aes(y = -3, yend = 0, x = x_pos-0.075, xend = x_pos-0.075), color = "black",linewidth=0.5)+
    theme_minimal(base_size = 11) +
    theme(
      legend.title = element_blank(),
      legend.position = if (legend) "top" else "none",
      legend.text = element_text(size = 27),
      panel.grid = element_blank(),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.title.y = element_text(size = 25, color = "black", margin = margin(r = 35)),
      axis.title.x = element_blank(),
      plot.margin = margin(t = 35, r = 200, b = 5, l = 10),
      text = element_text(face = "plain"),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "transparent", colour = NA)
    ) +
    coord_cartesian(ylim = c(0, 100),clip = "off")

  if (y_tick) {
    p <- p +
      geom_segment(
        aes(y = 0, yend = 40, x = 0.65, xend = 0.65),
        color = "black",
        linewidth = 0.5
      ) +
      geom_segment(
        data = data.frame(
          x = 0.65,
          xend = 0.6,
          y = seq(0, 40, 20),
          yend = seq(0, 40, 20)
        ),
        aes(x = x, xend = xend, y = y, yend = yend),
        color = "black",
        linewidth = 0.5,
        inherit.aes = FALSE
      )+
      annotate("text",x = 0.55,y = seq(0,40,20),label = seq(0,40,20),hjust = 1,size = 8)
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
    p <- p +
      guides(
        fill = guide_legend(
          order = 1,
          keywidth = unit(1.4, "cm"),
          keyheight = unit(0.5, "cm"),
          override.aes = list(
            pattern = c("stripe", "circle"),
            pattern_fill = "#393a3d",
            pattern_colour = "#393a3d",
            color = "#393a3d"
          )
        ),
        color = "none",
        pattern = "none"
      ) +
      theme(
        legend.key = element_rect(
          colour = "#393a3d",
          linewidth = 3.5
        ),
        legend.text = element_text(size = 27)
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

p_sub_hc <- plot_sub(sub_df_he_cog, y_label=FALSE)
p_sub_ac <- plot_sub(sub_df_ad_cog, y_label=FALSE)
p_sub_hm <- plot_sub(sub_df_he_men, y_label=FALSE)
p_sub_am <- plot_sub(sub_df_ad_men, y_label=FALSE)
p_legend2 <- plot_sub(sub_df_ad_men, legend=TRUE)


###             ###
### panel_b_time ###
###             ###
p_time <- ggplot(Time_box_stats, aes(x = x_pos)) +
  geom_rect_pattern(
    aes(
      xmin = x_pos - 0.2,
      xmax = x_pos + 0.2,
      ymin = q1,
      ymax = q3,
      fill = Group,
      colour = Group,
      pattern = Group
    ),
    linewidth = 0.5,
    pattern_fill = "#393a3d",
    pattern_colour = "#393a3d",
    pattern_density = 0.15,
    pattern_spacing = 0.03,
    pattern_angle = 45
  ) +
  geom_segment(
    aes(
      x = x_pos - 0.2,
      xend = x_pos + 0.2,
      y = median,
      yend = median,
      colour = Group
    ),
    linewidth = 0.8
  ) +
  geom_segment(
    aes(
      x = x_pos,
      xend = x_pos,
      y = lower,
      yend = q1,
      colour = Group
    ),
    linewidth = 0.5
  ) +
  geom_segment(
    aes(
      x = x_pos,
      xend = x_pos,
      y = q3,
      yend = upper,
      colour = Group
    ),
    linewidth = 0.5
  ) +
  geom_segment(
    aes(
      x = x_pos - 0.1,
      xend = x_pos + 0.1,
      y = lower,
      yend = lower,
      colour = Group
    ),
    linewidth = 0.5
  ) +
  geom_segment(
    aes(
      x = x_pos - 0.1,
      xend = x_pos + 0.1,
      y = upper,
      yend = upper,
      colour = Group
    ),
    linewidth = 0.5
  )+
  scale_pattern_manual(
    values = c(
      "ZheePal" = "none",
      "No diagnosis" = "none",
      "No guidance" = "none",
      "Time controlled" = "stripe",
      "Free conversation" = "circle"
    ),
    guide = "none"
  ) +
  scale_fill_manual(values = c(
    "ZheePal" = "#E890C5",
    "No diagnosis" = "#c5c9ba",
    "No guidance" = "#c5c9dc",
    "Time controlled" = "#ecedef",
    "Free conversation" = "#ecedef"
  ),
  labels = c(
    "ZheePal" = "ZheePal     ",
    "No diagnosis" = "No diagnosis     ",
    "No guidance" = "No guidance     ",
    "Time controlled" = "Time controlled     ",
    "Free conversation" = "Free conversation"
  )) +
  scale_colour_manual(values = c(
    "ZheePal" = "#C72D94",
    "No diagnosis" = "#3E4A1A",
    "No guidance" = "#3E4A8B",
    "Time controlled" = "#393a3d",
    "Free conversation" = "#393a3d"
  ),
  labels =c(
    "ZheePal" = "ZheePal     ",
    "No diagnosis" = "No diagnosis     ",
    "No guidance" = "No guidance     ",
    "Time controlled" = "Time controlled     ",
    "Free conversation" = "Free conversation"
  )) +
  scale_y_continuous(
    breaks = seq(0, 80, 20)
  ) +
  coord_cartesian(ylim = c(0, 80), clip = "off") +
  geom_segment(x = 0.5, xend = 5.5, y = -2, yend = -2,
               color = "black", linewidth = 0.5) +
  geom_segment(y = 0, yend = 80, x = 0.45, xend = 0.45,
               color = "black", linewidth = 0.5) +
  geom_segment(x = 0.5, xend = 0.5, y = -2, yend = -3,
               color = "black", linewidth = 0.5) +
  geom_segment(x = 5.5, xend = 5.5, y = -2, yend = -3,
               color = "black", linewidth = 0.5) +
  geom_segment(
    data = data.frame(y = seq(0, 80, 20)),
    aes(x = 0.45, xend = 0.38, y = y, yend = y),
    inherit.aes = FALSE,
    color = "black",
    linewidth = 0.5
  ) +
  labs(
    x = NULL,
    y = "Duration (min)"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    legend.position = "none",

    axis.text.x = element_blank(),
    axis.text.y = element_text(size = 24, color = "black", margin = margin(r = 5)),
    axis.ticks = element_blank(),
    axis.title.y = element_text(size = 26, margin = margin(r = 30)),
    plot.margin = margin(t = 110, r = 530, b = 30, l = 30),
    text = element_text(face = "plain"),
    panel.background = element_rect(fill = "transparent", colour = NA),
    plot.background = element_rect(fill = "transparent", colour = NA)
  )


ggsave("plot/fig5/legend1.pdf", plot = p_legend1, width = 12, height = 3, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig5/p_main_h.pdf", plot = p_main_h, width = 12, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig5/p_main_a.pdf", plot = p_main_a, width = 12, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig5/legend2.pdf", plot = p_legend2, width = 16, height = 2, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig5/p_sub_hc.pdf", plot = p_sub_hc, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig5/p_sub_ac.pdf", plot = p_sub_ac, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig5/p_sub_hm.pdf", plot = p_sub_hm, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig5/p_sub_am.pdf", plot = p_sub_am, width = 8, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig5/p_time.pdf", plot = p_time, width = 13, height = 7, device = cairo_pdf, family = "Aptos", bg = "transparent")
