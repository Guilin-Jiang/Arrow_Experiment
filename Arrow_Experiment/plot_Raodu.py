import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import UnivariateSpline

# 数据
angles = np.array([30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 360])
deflections = np.array([542.5, 543.5, 547.75, 545.75, 545.5, 545.75, 543.75, 543.75, 545, 546.5, 546.75, 542.25])

# 样条插值拟合
spline_model = UnivariateSpline(angles, deflections, k=3, s=0)
fine_angles = np.linspace(30, 360, 360)  # 平滑角度范围
spline_fitted = spline_model(fine_angles)

# 绘制图表
plt.figure(figsize=(10, 6))
plt.scatter(angles, deflections, color='red', label='Measured Data')
plt.plot(fine_angles, spline_fitted, color='blue', label='Spline Fit', linestyle='--')
plt.xticks(np.arange(30, 361, 30))  # 设置每30度刻度
plt.xlabel('Rotation Angle (degrees)')
plt.ylabel('Deflection (average)')
plt.title('Arrow 2 Deflection vs Rotation Angle')
plt.legend()
plt.grid()
plt.show()
