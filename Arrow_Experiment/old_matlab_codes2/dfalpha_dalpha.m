function dfalpha = dfalpha_dalpha(alpha, z0, m, v0, g, t)
    % 计算A(alpha)关于alpha的偏导数
    dCalpha_dalpha = -m * v0 / alpha^2 - 2 * m^2 * g / alpha^3;
    Dalpha = 1 - exp(-alpha / m * t);
    Calpha = m * v0 / alpha + m^2 * g / alpha^2;
    dDalpha_dalpha = t / m * exp(-alpha / m * t);
    
    dAalpha_dalpha = dCalpha_dalpha * Dalpha + Calpha * dDalpha_dalpha;
    
    % 计算B(alpha)关于alpha的偏导数
    dBalpha_dalpha = m * g * t / alpha^2;
    
    % 合并偏导数
    dfalpha = dAalpha_dalpha + dBalpha_dalpha;
end