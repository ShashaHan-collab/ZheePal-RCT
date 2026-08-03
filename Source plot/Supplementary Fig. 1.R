library(ggplot2)
library(cowplot)
library(dplyr)

load("Supplementary Fig. 1.RData")

bar<-function(D, xlabel, x_label=FALSE){
  colnames(D) <- c("Dimension", "Value")
  num_t <- D$Value[D$Dimension == "num_t"]
  D <- D %>%
    filter(Dimension != "num_t") %>%
    mutate(
      Value = Value * 1,
      Dimension = factor(Dimension, levels = Dimension) 
    )
  
  D <- D %>%
    mutate(
      Dimension = factor(
        Dimension,
        levels = c(
          "Low",
          "Moderately low",
          "Moderate",
          "Moderately high",
          "High"
        ),
        labels = c(
          "Low",
          "Moderately\nlow",
          "Moderate",
          "Moderately\nhigh",
          "High"
        )
      )
    )
  p <- ggplot(D, aes(x = Dimension, y = Value)) +
    geom_col(width = 0.7, fill = "#00b0be") +
    scale_y_continuous(
      breaks = (c(0, 20, 40, 60, 80))
    ) +
    coord_cartesian(ylim = c(0, 80),clip = "off")+
    labs(
      x = NULL, y = NULL 
    )  +
    geom_segment(y = 0, yend = 80, x = 0.3, xend = 0.3, color = "black",linewidth=0.5)+
    geom_segment(data = data.frame(
      x = 0.3, xend = 0.2,
      y = seq(0, 80, 20),
      yend = seq(0, 80, 20)),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.5, inherit.aes = FALSE
    )+
    geom_segment(x = 0.5, xend = 5.5, y = -3, yend = -3, color = "black", linewidth = 0.5) +
    geom_segment(x = 0.5, xend = 0.5, y = -3, yend = -6, color = "black", linewidth = 0.5) +
    geom_segment(x = 5.5, xend = 5.5, y = -3, yend = -6, color = "black", linewidth = 0.5) +
    theme_minimal() +
    theme(
      axis.text.x = if (x_label) element_text(size = 24, color = "black") else element_blank(),
      axis.text.y = element_text(size = 26, color = "black", margin = margin(r = 20)),
      axis.title.y = element_text(size = 31, margin = margin(r = 35)),
      legend.position = "none",
      panel.grid = element_blank(),
      axis.ticks.y = element_blank(),
      axis.ticks.x = element_blank(),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "transparent", colour = NA),
      plot.margin = margin(t = 60, r = 5, b = 10, l = 0)
    )+
    annotate("text", x = 0.05, y = 90, label = xlabel,size = 10, hjust = 0)
  
  return(p)
}

p_cog<-bar(cog, "Cognitive decline")
p_an<-bar(an, "Anxiety")
p_de<-bar(de, "Depression", x_label = TRUE)
p_lo<-bar(lo, "Loneliness", x_label = TRUE)

p11<-plot_grid(p_cog,p_de, ncol=1,rel_heights = c(1,1.15))
p22<-plot_grid(p_an,p_lo, ncol=1,rel_heights = c(1,1.15))
p<-plot_grid(p11,p22, nrow=1,rel_widths = c(1,1))
y_label <- ggdraw() +
  draw_label(
    "Number of participants",
    angle = 90,
    x = 0.3, y = 0.55,
    size = 20,
    fontface = "plain"
  )
ggsave("plot/fig_risk_assessment/risk_assessment.pdf", plot = p, width = 20, height = 11, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig_risk_assessment/label.pdf", plot = y_label, width = 1, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
