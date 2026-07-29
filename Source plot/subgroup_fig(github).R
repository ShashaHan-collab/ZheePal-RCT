library(tibble)
library(ggplot2)
library(cowplot)
library(grid)

load("subgroup_fig.RData")

plot_sub <- function(var_name, save_dir = "plot/subfig", x_xlabel=FALSE, y_ylabel=FALSE) {
  df_all <- get(paste0("df_", var_name))
  levels <- var_config[[var_name]]
  n_cat <- length(levels(df_all$category))
  if(n_cat == 2){
    legend_pos <- c(0.95, 0.95)   
    ncol_legend <- 1
  }else if(var_name %in% c("income", "edu")){
    legend_pos <- c(0.98, 0.9)   
    ncol_legend <- 2
  } else {
    legend_pos <- c(0.95, 0.9)   
    ncol_legend <- 2
  }
  colors <- setNames(levels$color, levels$label)
  hjust_values <- setNames(levels$hjust, levels$label)
  vjust_values <- setNames(levels$vjust, levels$label)
  
  annot_df <- data.frame(
    indicator = c("Help-seeking", "Advice adherence"),
    x = c(1.5, 1.5),
    y = c(-13, -13),
    label = c("Help-seeking", "Advice adherence")
  )
  
  p <- ggplot(df_all, aes(x = x_group, y = value, fill = category)) +
    geom_col(width = 0.7,position = position_dodge(width = 0.6))+
    geom_errorbar(aes(ymin = lower, ymax = upper),
                  position = position_dodge(width = 0.6), width = 0, color = "black") +
    scale_fill_manual(values = colors) +
    scale_y_continuous(
      breaks = seq(0, 100, 20)
    ) +
    coord_cartesian(ylim = c(0, 100),clip = "off")+
    geom_segment(aes(y = 0, yend = 100, x = 0.3, xend = 0.3), color = "black",linewidth=0.3)+
    geom_segment(data = data.frame(
      x = 0.3, xend = 0.2,
      y = seq(0, 100, 20),
      yend = seq(0, 100, 20)),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.3, inherit.aes = FALSE
    )+
    labs(x = NULL, y = if (y_ylabel) "Difference (percentage point)" else "") +
    theme_classic() +
    theme(
      axis.text.x = element_blank(),
      axis.text.y = element_text(size = 16, color = "black", margin = margin(r = -2)),
      axis.title.y = if (y_ylabel) element_text(size = 18, margin = margin(r = 8)) else element_blank(),
      axis.ticks.y  = element_blank(),
      axis.ticks.length = unit(0.5, "lines"),
      axis.line.y = element_blank(),
      axis.ticks.x = element_blank(),
      axis.line.x = element_blank(),
      legend.title = element_blank(),
      legend.position = legend_pos,
      legend.text = element_text(size = 15),
      legend.justification = c(1, 0.5),
      strip.text.x = element_blank(),
      plot.margin = margin(t = 5, r = 5, b = 40, l = 5)
    ) +
    guides(color = guide_legend(ncol = ncol_legend, byrow = TRUE))
  
  if (x_xlabel){
    p <- p +
      geom_segment(aes(y = -19, yend = -15, x = 0.9, xend = 0.9), color = "black",linewidth=0.3)+
      geom_segment(aes(y = -19, yend = -15, x = 2.1, xend = 2.1), color = "black",linewidth=0.3)+
      geom_segment(aes(y = -15, yend = -15, x = 0.9, xend = 2.1), color = "black",linewidth=0.3)+
      geom_segment(aes(y = -19, yend = -15, x = 2.9, xend = 2.9), color = "black",linewidth=0.3)+
      geom_segment(aes(y = -19, yend = -15, x = 4.1, xend = 4.1), color = "black",linewidth=0.3)+
      geom_segment(aes(y = -15, yend = -15, x = 2.9, xend = 4.1), color = "black",linewidth=0.3)+
      annotate("text",x = 1,y = -6,label = "Cognitive", size = 5,fontface = "plain")+
      annotate("text",x = 2,y = -6,label = "Mental", size = 5,fontface = "plain")+
      annotate("text",x = 3,y = -6,label = "Cognitive", size = 5,fontface = "plain")+
      annotate("text",x = 4,y = -6,label = "Mental", size = 5,fontface = "plain")+
      annotate("text",x = 1.5,y = -25,label = "Help-seeking", size = 6,fontface = "plain")+
      annotate("text",x = 3.5,y = -25,label = "Advice adherence", size = 6,fontface = "plain")
  }
  
  if(!dir.exists(save_dir)) dir.create(save_dir, recursive = TRUE)
  save_path <- file.path(save_dir, paste0(var_name, ".pdf"))
  ggsave(save_path, plot = p, width = 5, height = 3.5, device = cairo_pdf, family = "Aptos", bg = "transparent")
  
  
  
  return(p)
}

var_config <- list(
  age = tibble(
    file = c("lt_65", "≥65"),
    label = c("Aged<65", "Aged≥65"),
    color = c("#e2f2fe", "#afd5ed"),
    hjust = c(1.2, -0.3),
    vjust = c(-0.3, -0.3),
    title = "Age",
    lc = "a"
  ),
  sex = tibble(
    file = c("Male", "Female"),
    label = c("Male", "Female"),
    color = c("#fce7d0", "#fcc997"),
    hjust = c(1.2, -0.3),
    vjust = c(-0.3, -0.3),
    title = "Sex",
    lc = "b"
  ),
  ethnic = tibble(
    file = c("Han", "Other races"),
    label = c("Han", "Other races"),
    color = c("#f5f1bf", "#e3e384"),
    hjust = c(1.2, -0.3),
    vjust = c(-0.3, -0.3),
    title = "Ethnicity",
    lc = "c"
  ),
  medical_level = tibble(
    file = c("城市", "乡镇"),
    label = c("Urban", "Rural"),
    color = c("#f9d8d5", "#e9a1a5"),
    hjust = c(1.2, -0.3),
    vjust = c(-0.3, -0.3),
    title = "Rural/Urban residency",
    lc = "d"
  ),
  live = tibble(
    file = c("与家人同住", "一个人在家住_养老机构"),
    label = c("With family", "Alone"),
    color = c("#fff1cd", "#f7e093"),
    hjust = c(1.2, -0.3),
    vjust = c(-0.3, -0.3),
    title = "Living status",
    lc = "e"
  ),
  edu = tibble(
    file = c("大专、本科及以上", "中学", "小学及以下"),
    label = c("College or above", "High school", "Primary school or below"),
    color = c("#e5f2f7", "#c0e2e5", "#a4dede"),
    hjust = c(1.2, 0.4, -0.3),
    vjust = c(-0.3, -1.2, -0.3),
    title = "Education attainment",
    lc = "f"
  ),
  job = tibble(
    file = c("Employed", "Retired", "Unemployed"),
    label = c("Employed", "Retired", "Unemployed"),
    color = c("#f9ede1", "#e7d0bd", "#caab93"),
    hjust = c(1.2, 0.4, -0.3),
    vjust = c(-0.3, -1.2, -0.3),
    title = "Employment status",
    lc = "g"
  )
  ,
  income = tibble(
    file = c("gt_5000", "(2000, 5000]", "≤2000"),
    label = c("Income>5000", "Income(2000, 5000]", "Income ≤2000"),
    color = c("#ecf2e2", "#d0e5bc", "#afd9a1"),
    hjust = c(1.2, 0.4, -0.3),
    vjust = c(-0.3, -1.2, -0.3),
    title = "Income levels",
    lc = "h"
  )
)

xy_var = c()
x_var = c("income", "live", "edu", "job")
y_var = c()

for (var in names(var_config)) {
  if (var %in%  x_var){
    plot_sub(var, x_xlabel=TRUE)
  } else if (var %in% y_var) {
    plot_sub(var, y_ylabel = TRUE)
  } else if (var %in% xy_var) {
    plot_sub(var, x_xlabel=TRUE, y_ylabel = TRUE)
  } else {
    plot_sub(var)
  }
}
legend_label <- ggdraw() +
  draw_grob(
    gridtext::richtext_grob(
      "Difference (percentage point)",
      x = 0.4, y = 0.3,
      hjust = 0, vjust = 0,
      gp = gpar(fontsize = 16),
      rot = 90
    )
  )
ggsave("plot/subfig/y_label.pdf", plot = legend_label, width = 1, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")

