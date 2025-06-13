using Random
using Plots
using LaTeXStrings

# スピン配位の初期化
function spins_initialize(Lx, Ly, rng)
    return rand(rng, [-1, 1], Lx, Ly)
end

# Siの計算
function Si_calculation(Ck, ix, iy, Lx, Ly)
    jx = ix + 1
    if jx > Lx
        jx -= Lx
    end
    jy = iy
    Si = Ck[jx, jy]

    jx = ix - 1
    if jx < 1
        jx += Lx
    end
    jy = iy
    Si += Ck[jx, jy]

    jx = ix
    jy = iy + 1
    if jy > Ly
        jy -= Ly
    end
    Si += Ck[jx, jy]

    jx = ix
    jy = iy - 1
    if jy < 1
        jy += Ly
    end
    Si += Ck[jx, jy]

    return Si
end

# エネルギーの計算
function E_measure(Ck, J, h, Lx, Ly)
    E = 0
    for iy = 1:Ly
        for ix = 1:Lx
            Si = Si_calculation(Ck, ix, iy, Lx, Ly)
            σi = Ck[ix, iy]
            E += -(J/2)*σi*Si - h*σi
        end
    end
    return E
end

# エネルギー差の計算
function ΔE_calculation(Ck, J, h, ix, iy, Lx, Ly)
    Si = Si_calculation(Ck, ix, iy, Lx, Ly)
    return 2J*Ck[ix, iy]*Si + 2h*Ck[ix, iy]
end

# メトロポリスモンテカルロ法によるスピンの更新
function spins_update(Ck, ix, iy, J, h, T, Lx, Ly, rng)
    ΔE = ΔE_calculation(Ck, J, h, ix, iy, Lx, Ly)
    σi = Ck[ix, iy]
    σ_new = ifelse(rand(rng)≤exp(-ΔE/T), -σi, σi)
    return σ_new
end


# メトロポリスモンテカルロ法の実行，各種物理量の計算
function Ising_Montecarlo(step_equilibration, step_MC, measure_interval, J, h, T, Lx, Ly)
    rng = MersenneTwister(123)  # 乱数の種
    count_measure = 0  # 測定回数
    E_mean = 0  # エネルギーの時間平均
    E2_mean = 0  # エネルギーの2乗の時間平均
    m_mean = 0  # 磁化の時間平均
    absm_mean = 0  # 磁化の絶対値の時間平均

    Ck = spins_initialize(Lx, Ly, rng)

    for trial = 1:step_equilibration+step_MC
        for ix = 1:Lx
            for iy = 1:Ly
                Ck[ix, iy] = spins_update(Ck, ix, iy, J, h, T, Lx, Ly, rng)
            end
        end

        if trial > step_equilibration && trial % measure_interval == 0
            count_measure += 1
            E = E_measure(Ck, J, h, Lx, Ly) / (Lx*Ly)
            E_mean += E
            E2_mean += E^2
            m = sum(Ck) / (Lx*Ly)  # 磁化の計算
            m_mean += m
            absm_mean += abs(m)
        end
    end

    E_mean /= count_measure
    E2_mean /= count_measure
    m_mean /= count_measure
    absm_mean /= count_measure
    C_mean = (E2_mean-E_mean^2) / T^2

    return E_mean, m_mean, absm_mean, C_mean
end

# 上記の設定でシミュレーションを実行
function test()
    step_equilibration = 10000  # 熱平衡に達するまでのステップ数
    step_MC = 50000  # 時間平均計算に用いるステップ数
    measure_interval = 10  # 数値の測定間隔
    J = 1  # 交換相互作用定数
    h = 0  # 外部磁場
    Ts = range(0.01, 5, length=200)  # 温度
    Lx = 50  # 格子のサイズ
    Ly = 50
    E_T = []  # 各温度におけるエネルギー
    m_T = []  # 各温度における磁化
    absm_T = []  # 各温度における磁化の絶対値
    C_T = []  # 各温度における比熱

    # 各温度で各種物理量を計算，記録
    for T in Ts
        E_mean, m_mean, absm_mean, C_mean = Ising_Montecarlo(step_equilibration, step_MC, measure_interval, J, h, T, Lx, Ly)
        push!(E_T, E_mean)
        push!(m_T, m_mean)
        push!(absm_T, absm_mean)
        push!(C_T, C_mean)
    end

    # グラフ描画
    plot(Ts, E_T, label="", xlabel=L"k_{\textrm{B}}T", ylabel="Energy", title="Temperature Dependence of Energy")
    savefig("E_Tdep.png")
    plot(Ts, m_T, label="", xlabel=L"k_{\textrm{B}}T", ylabel="Magnetization", title="Temperature Dependence of Magnetization")
    savefig("m_Tdep.png")
    plot(Ts, absm_T, label="", xlabel=L"k_{\textrm{B}}T", ylabel="Absolute Value of Magnetization", title="Temperature Dependence of Magnetization")
    savefig("absm_Tdep.png")
    plot(Ts, C_T, label="", xlabel=L"k_{\textrm{B}}T", ylabel="Specific Heat", title="Temperature Dependence of Specific Heat")
    savefig("C_Tdep.png")
end

test()
