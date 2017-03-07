function MOD = BESD_1_0_0(uniqID)

%===============================================================================
% This file was created using VAPP, the Berkeley Verilog-A Parser and Processor.   
% Last modified: 05-Mar-2017 16:52:28
% VAPP version: no_branch_name:fffffff
%===============================================================================

    MOD = ModSpec_common_skeleton();

    MOD.parm_types = {};
    MOD.u_names = {};
    MOD.IO_names = {};
    MOD.OtherIO_names = {};
    MOD.NIL.io_types = {};
    MOD.NIL.io_nodenames = {};
    MOD.limited_var_names = {};
    MOD.vecXY_to_limitedvars_matrix = [];
    MOD.uniqID = [];

    MOD.support_initlimiting = 1;

    if nargin > 0
        MOD.uniqID = uniqID;
    end

    MOD.model_name = 'BESD_1_0_0';
    MOD.NIL.node_names = {'p', 'n'};
    MOD.NIL.refnode_name = 'n';

    parmNameDefValArr = {'parm_Gon', 0.1,...
                         'parm_VH', 16,...
                         'parm_VT1', 48,...
                         'parm_VIH', 26,...
                         'parm_Is', 1e-12,...
                         'parm_VT', 0.026,...
                         'parm_VD', 0.7,...
                         'parm_K', 10,...
                         'parm_Alpha', 5,...
                         'parm_C', 1e-12,...
                         'parm_tau', 1e-08,...
                         'parm_maxslope', 1000000000000000,...
                         'parm_smoothing', 1e-10};

    nParm = 13;
    MOD.parm_names = {};
    MOD.parm_defaultvals = {};
    MOD.parm_vals = {};
    MOD.parm_given_flag = zeros(1, nParm);
    for parmIdx = 1:nParm
        MOD.parm_names{parmIdx} = parmNameDefValArr{2*parmIdx-1};
        MOD.parm_defaultvals{parmIdx} = parmNameDefValArr{2*parmIdx};
        MOD.parm_vals{parmIdx} = parmNameDefValArr{2*parmIdx};
    end

    [eonames, iunames, ienames] = get_oui_names__(MOD);
    MOD.explicit_output_names = eonames;
    MOD.internal_unk_names = iunames;
    MOD.implicit_equation_names = ienames;
    MOD.InternalUnkNames = @get_iu_names__;
    MOD.ImplicitEquationNames = @get_ie_names__;

    MOD = setup_IOnames_OtherIOnames_IOtypes_IOnodenames(MOD);

    MOD.fqeiJ = @fqeiJ;
    MOD.fe = @fe_from_fqeiJ_ModSpec;
    MOD.qe = @qe_from_fqeiJ_ModSpec;
    MOD.fi = @fi_from_fqeiJ_ModSpec;
    MOD.qi = @qi_from_fqeiJ_ModSpec;
    MOD.fqei = @fqei_from_fqeiJ_ModSpec;
    MOD.fqeiJ = @fqeiJ;

    MOD.dfe_dvecX = @dfe_dvecX_from_fqeiJ_ModSpec;
    MOD.dfe_dvecY = @dfe_dvecY_from_fqeiJ_ModSpec;
    MOD.dfe_dvecLim = @dfe_dvecLim_from_fqeiJ_ModSpec;
    MOD.dfe_dvecU = @dfe_dvecU_from_fqeiJ_ModSpec;

    MOD.dqe_dvecX = @dqe_dvecX_from_fqeiJ_ModSpec;
    MOD.dqe_dvecY = @dqe_dvecY_from_fqeiJ_ModSpec;
    MOD.dqe_dvecLim = @dqe_dvecLim_from_fqeiJ_ModSpec;

    MOD.dfi_dvecX = @dfi_dvecX_from_fqeiJ_ModSpec;
    MOD.dfi_dvecY = @dfi_dvecY_from_fqeiJ_ModSpec;
    MOD.dfi_dvecLim = @dfi_dvecLim_from_fqeiJ_ModSpec;
    MOD.dfi_dvecU = @dfi_dvecU_from_fqeiJ_ModSpec;

    MOD.dqi_dvecX = @dqi_dvecX_from_fqeiJ_ModSpec;
    MOD.dqi_dvecY = @dqi_dvecY_from_fqeiJ_ModSpec;
    MOD.dqi_dvecLim = @dqi_dvecLim_from_fqeiJ_ModSpec;
end

function [fqei_out, J_out] = fqeiJ(vecX, vecY, vecLim, vecU, flag, MOD)
    if nargin < 6
        MOD = flag;
        flag = vecU;
        vecU = vecLim;
    end

    [fe, qe, fi, qi, d_fe_d_X, d_qe_d_X, d_fi_d_X, d_qi_d_X,...
    d_fe_d_Y, d_qe_d_Y, d_fi_d_Y, d_qi_d_Y] = fqei_dfqeidXYU(vecX, vecY, MOD);

    fqei_out.fe = fe;
    fqei_out.qe = qe;
    fqei_out.fi = fi;
    fqei_out.qi = qi;

    [nFeQe, nFiQi] = get_nfq__(MOD);

    J_out.Jfe.dfe_dvecX = d_fe_d_X;
    J_out.Jqe.dqe_dvecX = d_qe_d_X;
    J_out.Jfi.dfi_dvecX = d_fi_d_X;
    J_out.Jqi.dqi_dvecX = d_qi_d_X;
    J_out.Jfe.dfe_dvecY = d_fe_d_Y;
    J_out.Jqe.dqe_dvecY = d_qe_d_Y;
    J_out.Jfi.dfi_dvecY = d_fi_d_Y;
    J_out.Jqi.dqi_dvecY = d_qi_d_Y;
    J_out.Jfe.dfe_dvecU = zeros(nFeQe,0);
    J_out.Jfi.dfi_dvecU = zeros(nFiQi,0);
    J_out.Jfe.dfe_dvecLim = zeros(nFeQe, 0);
    J_out.Jqe.dqe_dvecLim = zeros(nFeQe, 0);
    J_out.Jfi.dfi_dvecLim = zeros(nFiQi, 0);
    J_out.Jqi.dqi_dvecLim = zeros(nFiQi, 0);
end

function [fe__, qe__, fi__, qi__,...
          d_fe_d_X__, d_qe_d_X__, d_fi_d_X__, d_qi_d_X__,...
          d_fe_d_Y__, d_qe_d_Y__, d_fi_d_Y__, d_qi_d_Y__] = ...
         fqei_dfqeidXYU(vecX__, vecY__, MOD__)

    % initializing parameters
    parm_Gon = MOD__.parm_vals{1};
    parm_VH = MOD__.parm_vals{2};
    parm_VT1 = MOD__.parm_vals{3};
    parm_VIH = MOD__.parm_vals{4};
    parm_Is = MOD__.parm_vals{5};
    parm_VT = MOD__.parm_vals{6};
    parm_VD = MOD__.parm_vals{7};
    parm_K = MOD__.parm_vals{8};
    parm_Alpha = MOD__.parm_vals{9};
    parm_C = MOD__.parm_vals{10};
    parm_tau = MOD__.parm_vals{11};
    parm_maxslope = MOD__.parm_vals{12};
    parm_smoothing = MOD__.parm_vals{13};

    [nFeQe__, nFiQi__, nOtherIo__, nIntUnk__] = get_nfq__(MOD__);

    % Initializing outputs
    fe__ = zeros(nFeQe__,1);
    qe__ = zeros(nFeQe__,1);
    fi__ = zeros(nFiQi__,1);
    qi__ = zeros(nFiQi__,1);
    % Initializing derivatives
    d_fe_d_X__ = zeros(nFeQe__,nOtherIo__);
    d_qe_d_X__ = zeros(nFeQe__,nOtherIo__);
    d_fi_d_X__ = zeros(nFiQi__,nOtherIo__);
    d_qi_d_X__ = zeros(nFiQi__,nOtherIo__);
    d_fe_d_Y__ = zeros(nFeQe__,nIntUnk__);
    d_qe_d_Y__ = zeros(nFeQe__,nIntUnk__);
    d_fi_d_Y__ = zeros(nFiQi__,nIntUnk__);
    d_qi_d_Y__ = zeros(nFiQi__,nIntUnk__);
    % initializing variables
    d_Ioff_d_v_pn__ = 0;
    d_Ion_d_v_pn__ = 0;
    d_Vstar_d_v_pn__ = 0;
    d_f_i_nsn_d_v_nsn__ = 0;
    d_f_i_nsn_d_v_pn__ = 0;
    d_f_i_pn_d_v_nsn__ = 0;
    d_f_i_pn_d_v_pn__ = 0;
    d_q_i_nsn_d_v_nsn__ = 0;
    d_q_i_nsn_d_v_pn__ = 0;
    d_q_i_pn_d_v_nsn__ = 0;
    d_q_i_pn_d_v_pn__ = 0;
    d_s_d_v_nsn__ = 0;
    d_sstar_d_v_nsn__ = 0;
    % Initializing inputs
    v_pn__ = vecX__(1);
    v_nsn__ = vecY__(1);
    % Initializing remaining IOs and auxiliary IOs
    f_i_pn__ = 0;
    q_i_pn__ = 0;
    f_i_nsn__ = 0;
    q_i_nsn__ = 0;
    % module body
        d_s_d_v_nsn__ = 1;
    s = v_nsn__;
        d_Ion_d_v_pn__ = d_smoothclip_d_arg1__(parm_Gon*(v_pn__-parm_VH), parm_smoothing)*(parm_Gon*(1));
    Ion = smoothclip(parm_Gon*(v_pn__-parm_VH), parm_smoothing)-smoothclip(-parm_Gon*parm_VH, parm_smoothing);
        d_Ioff_d_v_pn__ = (parm_Is*(1-safeexp(-v_pn__/parm_VT, parm_maxslope)))*((1/(2*sqrt(1+max(v_pn__, 0)/parm_VD)))*(((gt(v_pn__, 0)*1)/parm_VD)))+(parm_Is*(-d_safeexp_d_arg1__(-v_pn__/parm_VT, parm_maxslope)*(-1/parm_VT)))*sqrt(1+max(v_pn__, 0)/parm_VD);
    Ioff = (parm_Is*(1-safeexp(-v_pn__/parm_VT, parm_maxslope)))*sqrt(1+max(v_pn__, 0)/parm_VD);
        d_f_i_pn_d_v_pn__ = d_f_i_pn_d_v_pn__+(d_Ioff_d_v_pn__+(pow_vapp(s, parm_Alpha)*d_Ion_d_v_pn__));
        d_f_i_pn_d_v_nsn__ = d_f_i_pn_d_v_nsn__+(((d_pow_vapp_d_arg1__(s, parm_Alpha)*d_s_d_v_nsn__)*Ion));
    % contribution for i_pn;
    f_i_pn__ = f_i_pn__ + Ioff+pow_vapp(s, parm_Alpha)*Ion;
        d_q_i_pn_d_v_pn__ = d_q_i_pn_d_v_pn__+parm_C*1;
        d_q_i_pn_d_v_nsn__ = d_q_i_pn_d_v_nsn__;
    % contribution for i_pn;
    q_i_pn__ = q_i_pn__ + parm_C*v_pn__;
        d_Vstar_d_v_pn__ = (2*((1)))/(parm_VT1-parm_VIH);
    Vstar = (2*((v_pn__-0.5*parm_VT1)-0.5*parm_VIH))/(parm_VT1-parm_VIH);
        d_sstar_d_v_nsn__ = 2*(d_s_d_v_nsn__);
    sstar = 2*(s-0.5);
        d_f_i_nsn_d_v_pn__ = d_f_i_nsn_d_v_pn__+((1/cosh(parm_K*(Vstar+sstar))^2)*(parm_K*(d_Vstar_d_v_pn__)));
        d_f_i_nsn_d_v_nsn__ = d_f_i_nsn_d_v_nsn__+((1/cosh(parm_K*(Vstar+sstar))^2)*(parm_K*(d_sstar_d_v_nsn__))-d_sstar_d_v_nsn__);
    % contribution for i_nsn;
    f_i_nsn__ = f_i_nsn__ + tanh(parm_K*(Vstar+sstar))-sstar;
        d_q_i_nsn_d_v_pn__ = d_q_i_nsn_d_v_pn__;
        d_q_i_nsn_d_v_nsn__ = d_q_i_nsn_d_v_nsn__+-parm_tau*d_s_d_v_nsn__;
    % contribution for i_nsn;
    q_i_nsn__ = q_i_nsn__ + -parm_tau*s;
        d_fe_d_X__(1,1) = -(-d_f_i_pn_d_v_pn__);
        d_qe_d_X__(1,1) = -(-d_q_i_pn_d_v_pn__);
        d_fe_d_Y__(1,1) = -(-d_f_i_pn_d_v_nsn__);
        d_qe_d_Y__(1,1) = -(-d_q_i_pn_d_v_nsn__);
    % output for terminalFlow_p (explicit out)
    fe__(1) = 0 + f_i_pn__;
    qe__(1) = 0 + q_i_pn__;
        d_fi_d_X__(1,1) = -d_f_i_nsn_d_v_pn__;
        d_qi_d_X__(1,1) = -d_q_i_nsn_d_v_pn__;
        d_fi_d_Y__(1,1) = -d_f_i_nsn_d_v_nsn__;
        d_qi_d_Y__(1,1) = -d_q_i_nsn_d_v_nsn__;
    % output for v_nsn (internal unknown)
    fi__(1) = 0 - f_i_nsn__;
    qi__(1) = 0 - q_i_nsn__;
end

function [eonames, iunames, ienames] = get_oui_names__(MOD__)
    eonames = {'ipn'};
    iunames = {'v_nsn'};
    ienames = {'KCL for i_nsn'};
end

function [nFeQe, nFiQi, nOtherIo, nIntUnk] = get_nfq__(MOD__)
    nFeQe = 1;
    nFiQi = 1;
    nOtherIo = 1;
    nIntUnk = 1;
end

function iun = get_iu_names__(MOD)
    [~, iun, ~] = get_oui_names__(MOD);
end

function ien = get_ie_names__(MOD)
    [~, ~, ien] = get_oui_names__(MOD);
end


function d_ddsmoothabs_d_x__ = d_ddsmoothabs_d_arg1__(x, smoothing)
    d_ddsmoothabs_d_x__ = 0;
        d_ddsmoothabs_d_x__ = ((-x/pow_vapp(smoothabs(x, smoothing), 2))*(d_dsmoothabs_d_arg1__(x, smoothing)*1)+(-1/pow_vapp(smoothabs(x, smoothing), 2)-(-x*(d_pow_vapp_d_arg1__(smoothabs(x, smoothing), 2)*(d_smoothabs_d_arg1__(x, smoothing)*1)))/pow_vapp(smoothabs(x, smoothing), 2)^2)*dsmoothabs(x, smoothing))+(-(1*(d_smoothabs_d_arg1__(x, smoothing)*1))/smoothabs(x, smoothing)^2);
    ddsmoothabs = (-x/pow_vapp(smoothabs(x, smoothing), 2))*dsmoothabs(x, smoothing)+1/smoothabs(x, smoothing);
end

function d_ddsmoothabs_d_smoothing__ = d_ddsmoothabs_d_arg2__(x, smoothing)
    d_ddsmoothabs_d_smoothing__ = 0;
        d_ddsmoothabs_d_smoothing__ = ((-x/pow_vapp(smoothabs(x, smoothing), 2))*(d_dsmoothabs_d_arg2__(x, smoothing)*1)+(-(-x*(d_pow_vapp_d_arg1__(smoothabs(x, smoothing), 2)*(d_smoothabs_d_arg2__(x, smoothing)*1)))/pow_vapp(smoothabs(x, smoothing), 2)^2)*dsmoothabs(x, smoothing))+(-(1*(d_smoothabs_d_arg2__(x, smoothing)*1))/smoothabs(x, smoothing)^2);
    ddsmoothabs = (-x/pow_vapp(smoothabs(x, smoothing), 2))*dsmoothabs(x, smoothing)+1/smoothabs(x, smoothing);
end

function d_ddsmoothclip_d_x__ = d_ddsmoothclip_d_arg1__(x, smoothing)
    d_ddsmoothclip_d_x__ = 0;
        d_ddsmoothclip_d_x__ = 0.5*(d_ddsmoothabs_d_arg1__(x, smoothing)*1);
    ddsmoothclip = 0.5*ddsmoothabs(x, smoothing);
end

function d_ddsmoothclip_d_smoothing__ = d_ddsmoothclip_d_arg2__(x, smoothing)
    d_ddsmoothclip_d_smoothing__ = 0;
        d_ddsmoothclip_d_smoothing__ = 0.5*(d_ddsmoothabs_d_arg2__(x, smoothing)*1);
    ddsmoothclip = 0.5*ddsmoothabs(x, smoothing);
end

function d_dsafeexp_d_x__ = d_dsafeexp_d_arg1__(x, maxslope)
    d_dsafeexp_d_x__ = 0;
    breakpoint = log(maxslope);
        d_dsafeexp_d_x__ = (exp(x*(x<=breakpoint))*0+(exp(x*(x<=breakpoint))*(x*0+1*(x<=breakpoint)))*(x<=breakpoint))+(0*maxslope);
    dsafeexp = exp(x*(x<=breakpoint))*(x<=breakpoint)+(x>breakpoint)*maxslope;
end

function d_dsafeexp_d_maxslope__ = d_dsafeexp_d_arg2__(x, maxslope)
    d_dsafeexp_d_maxslope__ = 0;
        d_breakpoint_d_maxslope__ = (1/maxslope)*1;
    breakpoint = log(maxslope);
        d_dsafeexp_d_maxslope__ = (exp(x*(x<=breakpoint))*0+(exp(x*(x<=breakpoint))*(x*0))*(x<=breakpoint))+((x>breakpoint)*1+0*maxslope);
    dsafeexp = exp(x*(x<=breakpoint))*(x<=breakpoint)+(x>breakpoint)*maxslope;
end

function d_dsafelog_d_x__ = d_dsafelog_d_arg1__(x, smoothing)
    d_dsafelog_d_x__ = 0;
        d_dsafelog_d_x__ = (1/(smoothclip(x, smoothing)+1e-16))*(d_dsmoothclip_d_arg1__(x, smoothing)*1)+(-(1*(d_smoothclip_d_arg1__(x, smoothing)*1))/(smoothclip(x, smoothing)+1e-16)^2)*dsmoothclip(x, smoothing);
    dsafelog = (1/(smoothclip(x, smoothing)+1e-16))*dsmoothclip(x, smoothing);
end

function d_dsafelog_d_smoothing__ = d_dsafelog_d_arg2__(x, smoothing)
    d_dsafelog_d_smoothing__ = 0;
        d_dsafelog_d_smoothing__ = (1/(smoothclip(x, smoothing)+1e-16))*(d_dsmoothclip_d_arg2__(x, smoothing)*1)+(-(1*((d_smoothclip_d_arg2__(x, smoothing)*1)))/(smoothclip(x, smoothing)+1e-16)^2)*dsmoothclip(x, smoothing);
    dsafelog = (1/(smoothclip(x, smoothing)+1e-16))*dsmoothclip(x, smoothing);
end

function d_dsafesinh_d_x__ = d_dsafesinh_d_arg1__(x, maxslope)
    d_dsafesinh_d_x__ = 0;
        d_dsafesinh_d_x__ = 0.5*(d_dsafeexp_d_arg1__(x, maxslope)*1-d_dsafeexp_d_arg1__(-x, maxslope)*-1);
    dsafesinh = 0.5*(dsafeexp(x, maxslope)-dsafeexp(-x, maxslope));
end

function d_dsafesinh_d_maxslope__ = d_dsafesinh_d_arg2__(x, maxslope)
    d_dsafesinh_d_maxslope__ = 0;
        d_dsafesinh_d_maxslope__ = 0.5*((d_dsafeexp_d_arg2__(x, maxslope)*1)-(d_dsafeexp_d_arg2__(-x, maxslope)*1));
    dsafesinh = 0.5*(dsafeexp(x, maxslope)-dsafeexp(-x, maxslope));
end

function d_dsafesqrt_d_x__ = d_dsafesqrt_d_arg1__(x, smoothing)
    d_dsafesqrt_d_x__ = 0;
        d_dsafesqrt_d_x__ = (0.5/sqrt(smoothclip(x, smoothing)+1e-16))*(d_dsmoothclip_d_arg1__(x, smoothing)*1)+(-(0.5*((1/(2*sqrt(smoothclip(x, smoothing)+1e-16)))*(d_smoothclip_d_arg1__(x, smoothing)*1)))/sqrt(smoothclip(x, smoothing)+1e-16)^2)*dsmoothclip(x, smoothing);
    dsafesqrt = (0.5/sqrt(smoothclip(x, smoothing)+1e-16))*dsmoothclip(x, smoothing);
end

function d_dsafesqrt_d_smoothing__ = d_dsafesqrt_d_arg2__(x, smoothing)
    d_dsafesqrt_d_smoothing__ = 0;
        d_dsafesqrt_d_smoothing__ = (0.5/sqrt(smoothclip(x, smoothing)+1e-16))*(d_dsmoothclip_d_arg2__(x, smoothing)*1)+(-(0.5*((1/(2*sqrt(smoothclip(x, smoothing)+1e-16)))*((d_smoothclip_d_arg2__(x, smoothing)*1))))/sqrt(smoothclip(x, smoothing)+1e-16)^2)*dsmoothclip(x, smoothing);
    dsafesqrt = (0.5/sqrt(smoothclip(x, smoothing)+1e-16))*dsmoothclip(x, smoothing);
end

function d_dsmoothabs_d_x__ = d_dsmoothabs_d_arg1__(x, smoothing)
    d_dsmoothabs_d_x__ = 0;
        d_dsmoothabs_d_x__ = 1/sqrt(x*x+smoothing)-(x*((1/(2*sqrt(x*x+smoothing)))*((x*1+1*x))))/sqrt(x*x+smoothing)^2;
    dsmoothabs = x/sqrt(x*x+smoothing);
end

function d_dsmoothabs_d_smoothing__ = d_dsmoothabs_d_arg2__(x, smoothing)
    d_dsmoothabs_d_smoothing__ = 0;
        d_dsmoothabs_d_smoothing__ = -(x*((1/(2*sqrt(x*x+smoothing)))*(1)))/sqrt(x*x+smoothing)^2;
    dsmoothabs = x/sqrt(x*x+smoothing);
end

function d_dsmoothclip_d_x__ = d_dsmoothclip_d_arg1__(x, smoothing)
    d_dsmoothclip_d_x__ = 0;
        d_dsmoothclip_d_x__ = (0.5*(d_dsmoothabs_d_arg1__(x, smoothing)*1));
    dsmoothclip = 0.5*dsmoothabs(x, smoothing)+0.5;
end

function d_dsmoothclip_d_smoothing__ = d_dsmoothclip_d_arg2__(x, smoothing)
    d_dsmoothclip_d_smoothing__ = 0;
        d_dsmoothclip_d_smoothing__ = (0.5*(d_dsmoothabs_d_arg2__(x, smoothing)*1));
    dsmoothclip = 0.5*dsmoothabs(x, smoothing)+0.5;
end

function d_dsmoothmax_da_d_a__ = d_dsmoothmax_da_d_arg1__(a, b, smoothing)
    d_dsmoothmax_da_d_a__ = 0;
        d_dsmoothmax_da_d_a__ = 0.5*(d_dsmoothabs_d_arg1__(a-b, smoothing)*(1));
    dsmoothmax_da = 0.5*(1+dsmoothabs(a-b, smoothing));
end

function d_dsmoothmax_da_d_b__ = d_dsmoothmax_da_d_arg2__(a, b, smoothing)
    d_dsmoothmax_da_d_b__ = 0;
        d_dsmoothmax_da_d_b__ = 0.5*(d_dsmoothabs_d_arg1__(a-b, smoothing)*(-1));
    dsmoothmax_da = 0.5*(1+dsmoothabs(a-b, smoothing));
end

function d_dsmoothmax_da_d_smoothing__ = d_dsmoothmax_da_d_arg3__(a, b, smoothing)
    d_dsmoothmax_da_d_smoothing__ = 0;
        d_dsmoothmax_da_d_smoothing__ = 0.5*((d_dsmoothabs_d_arg2__(a-b, smoothing)*1));
    dsmoothmax_da = 0.5*(1+dsmoothabs(a-b, smoothing));
end

function d_dsmoothmax_db_d_a__ = d_dsmoothmax_db_d_arg1__(a, b, smoothing)
    d_dsmoothmax_db_d_a__ = 0;
        d_dsmoothmax_db_d_a__ = 0.5*(-d_dsmoothabs_d_arg1__(a-b, smoothing)*(1));
    dsmoothmax_db = 0.5*(1-dsmoothabs(a-b, smoothing));
end

function d_dsmoothmax_db_d_b__ = d_dsmoothmax_db_d_arg2__(a, b, smoothing)
    d_dsmoothmax_db_d_b__ = 0;
        d_dsmoothmax_db_d_b__ = 0.5*(-d_dsmoothabs_d_arg1__(a-b, smoothing)*(-1));
    dsmoothmax_db = 0.5*(1-dsmoothabs(a-b, smoothing));
end

function d_dsmoothmax_db_d_smoothing__ = d_dsmoothmax_db_d_arg3__(a, b, smoothing)
    d_dsmoothmax_db_d_smoothing__ = 0;
        d_dsmoothmax_db_d_smoothing__ = 0.5*(-(d_dsmoothabs_d_arg2__(a-b, smoothing)*1));
    dsmoothmax_db = 0.5*(1-dsmoothabs(a-b, smoothing));
end

function d_dsmoothmin_da_d_a__ = d_dsmoothmin_da_d_arg1__(a, b, smoothing)
    d_dsmoothmin_da_d_a__ = 0;
        d_dsmoothmin_da_d_a__ = 0.5*(-d_dsmoothabs_d_arg1__(a-b, smoothing)*(1));
    dsmoothmin_da = 0.5*(1-dsmoothabs(a-b, smoothing));
end

function d_dsmoothmin_da_d_b__ = d_dsmoothmin_da_d_arg2__(a, b, smoothing)
    d_dsmoothmin_da_d_b__ = 0;
        d_dsmoothmin_da_d_b__ = 0.5*(-d_dsmoothabs_d_arg1__(a-b, smoothing)*(-1));
    dsmoothmin_da = 0.5*(1-dsmoothabs(a-b, smoothing));
end

function d_dsmoothmin_da_d_smoothing__ = d_dsmoothmin_da_d_arg3__(a, b, smoothing)
    d_dsmoothmin_da_d_smoothing__ = 0;
        d_dsmoothmin_da_d_smoothing__ = 0.5*(-(d_dsmoothabs_d_arg2__(a-b, smoothing)*1));
    dsmoothmin_da = 0.5*(1-dsmoothabs(a-b, smoothing));
end

function d_dsmoothmin_db_d_a__ = d_dsmoothmin_db_d_arg1__(a, b, smoothing)
    d_dsmoothmin_db_d_a__ = 0;
        d_dsmoothmin_db_d_a__ = 0.5*(d_dsmoothabs_d_arg1__(a-b, smoothing)*(1));
    dsmoothmin_db = 0.5*(1+dsmoothabs(a-b, smoothing));
end

function d_dsmoothmin_db_d_b__ = d_dsmoothmin_db_d_arg2__(a, b, smoothing)
    d_dsmoothmin_db_d_b__ = 0;
        d_dsmoothmin_db_d_b__ = 0.5*(d_dsmoothabs_d_arg1__(a-b, smoothing)*(-1));
    dsmoothmin_db = 0.5*(1+dsmoothabs(a-b, smoothing));
end

function d_dsmoothmin_db_d_smoothing__ = d_dsmoothmin_db_d_arg3__(a, b, smoothing)
    d_dsmoothmin_db_d_smoothing__ = 0;
        d_dsmoothmin_db_d_smoothing__ = 0.5*((d_dsmoothabs_d_arg2__(a-b, smoothing)*1));
    dsmoothmin_db = 0.5*(1+dsmoothabs(a-b, smoothing));
end

function d_dsmoothsign_d_x__ = d_dsmoothsign_d_arg1__(x, smoothing)
    d_dsmoothsign_d_x__ = 0;
        d_dsmoothsign_d_x__ = 2*(d_dsmoothstep_d_arg1__(x, smoothing)*1);
    dsmoothsign = 2*dsmoothstep(x, smoothing);
end

function d_dsmoothsign_d_smoothing__ = d_dsmoothsign_d_arg2__(x, smoothing)
    d_dsmoothsign_d_smoothing__ = 0;
        d_dsmoothsign_d_smoothing__ = 2*(d_dsmoothstep_d_arg2__(x, smoothing)*1);
    dsmoothsign = 2*dsmoothstep(x, smoothing);
end

function d_dsmoothstep_d_x__ = d_dsmoothstep_d_arg1__(x, smoothing)
    d_dsmoothstep_d_x__ = 0;
        d_dsmoothstep_d_x__ = d_ddsmoothclip_d_arg1__(x, smoothing)*1;
    dsmoothstep = ddsmoothclip(x, smoothing);
end

function d_dsmoothstep_d_smoothing__ = d_dsmoothstep_d_arg2__(x, smoothing)
    d_dsmoothstep_d_smoothing__ = 0;
        d_dsmoothstep_d_smoothing__ = d_ddsmoothclip_d_arg2__(x, smoothing)*1;
    dsmoothstep = ddsmoothclip(x, smoothing);
end

function d_dsmoothswitch_da_d_a__ = d_dsmoothswitch_da_d_arg1__(a, b, x, smoothing)
    d_dsmoothswitch_da_d_a__ = 0;
    oof = smoothstep(x, smoothing);
    dsmoothswitch_da = 1-oof;
end

function d_dsmoothswitch_da_d_b__ = d_dsmoothswitch_da_d_arg2__(a, b, x, smoothing)
    d_dsmoothswitch_da_d_b__ = 0;
    oof = smoothstep(x, smoothing);
    dsmoothswitch_da = 1-oof;
end

function d_dsmoothswitch_da_d_x__ = d_dsmoothswitch_da_d_arg3__(a, b, x, smoothing)
    d_dsmoothswitch_da_d_x__ = 0;
        d_oof_d_x__ = d_smoothstep_d_arg1__(x, smoothing)*1;
    oof = smoothstep(x, smoothing);
        d_dsmoothswitch_da_d_x__ = -d_oof_d_x__;
    dsmoothswitch_da = 1-oof;
end

function d_dsmoothswitch_da_d_smoothing__ = d_dsmoothswitch_da_d_arg4__(a, b, x, smoothing)
    d_dsmoothswitch_da_d_smoothing__ = 0;
        d_oof_d_smoothing__ = d_smoothstep_d_arg2__(x, smoothing)*1;
    oof = smoothstep(x, smoothing);
        d_dsmoothswitch_da_d_smoothing__ = -d_oof_d_smoothing__;
    dsmoothswitch_da = 1-oof;
end

function d_dsmoothswitch_db_d_a__ = d_dsmoothswitch_db_d_arg1__(a, b, x, smoothing)
    d_dsmoothswitch_db_d_a__ = 0;
    oof = smoothstep(x, smoothing);
    dsmoothswitch_db = oof;
end

function d_dsmoothswitch_db_d_b__ = d_dsmoothswitch_db_d_arg2__(a, b, x, smoothing)
    d_dsmoothswitch_db_d_b__ = 0;
    oof = smoothstep(x, smoothing);
    dsmoothswitch_db = oof;
end

function d_dsmoothswitch_db_d_x__ = d_dsmoothswitch_db_d_arg3__(a, b, x, smoothing)
    d_dsmoothswitch_db_d_x__ = 0;
        d_oof_d_x__ = d_smoothstep_d_arg1__(x, smoothing)*1;
    oof = smoothstep(x, smoothing);
        d_dsmoothswitch_db_d_x__ = d_oof_d_x__;
    dsmoothswitch_db = oof;
end

function d_dsmoothswitch_db_d_smoothing__ = d_dsmoothswitch_db_d_arg4__(a, b, x, smoothing)
    d_dsmoothswitch_db_d_smoothing__ = 0;
        d_oof_d_smoothing__ = d_smoothstep_d_arg2__(x, smoothing)*1;
    oof = smoothstep(x, smoothing);
        d_dsmoothswitch_db_d_smoothing__ = d_oof_d_smoothing__;
    dsmoothswitch_db = oof;
end

function d_dsmoothswitch_dx_d_a__ = d_dsmoothswitch_dx_d_arg1__(a, b, x, smoothing)
    d_dsmoothswitch_dx_d_a__ = 0;
    doof = dsmoothstep(x, smoothing);
        d_dsmoothswitch_dx_d_a__ = (-1)*doof;
    dsmoothswitch_dx = (-a+b)*doof;
end

function d_dsmoothswitch_dx_d_b__ = d_dsmoothswitch_dx_d_arg2__(a, b, x, smoothing)
    d_dsmoothswitch_dx_d_b__ = 0;
    doof = dsmoothstep(x, smoothing);
        d_dsmoothswitch_dx_d_b__ = (1)*doof;
    dsmoothswitch_dx = (-a+b)*doof;
end

function d_dsmoothswitch_dx_d_x__ = d_dsmoothswitch_dx_d_arg3__(a, b, x, smoothing)
    d_dsmoothswitch_dx_d_x__ = 0;
        d_doof_d_x__ = d_dsmoothstep_d_arg1__(x, smoothing)*1;
    doof = dsmoothstep(x, smoothing);
        d_dsmoothswitch_dx_d_x__ = (-a+b)*d_doof_d_x__;
    dsmoothswitch_dx = (-a+b)*doof;
end

function d_dsmoothswitch_dx_d_smoothing__ = d_dsmoothswitch_dx_d_arg4__(a, b, x, smoothing)
    d_dsmoothswitch_dx_d_smoothing__ = 0;
        d_doof_d_smoothing__ = d_dsmoothstep_d_arg2__(x, smoothing)*1;
    doof = dsmoothstep(x, smoothing);
        d_dsmoothswitch_dx_d_smoothing__ = (-a+b)*d_doof_d_smoothing__;
    dsmoothswitch_dx = (-a+b)*doof;
end

function d_outVal_d_base__ = d_pow_vapp_d_arg1__(base, exponent)
    d_outVal_d_base__ = 0;
        d_outVal_d_base__ = base^(exponent-1)*(1*exponent);
    outVal = base^exponent;
end

function d_outVal_d_exponent__ = d_pow_vapp_d_arg2__(base, exponent)
    d_outVal_d_exponent__ = 0;
        d_outVal_d_exponent__ = (base^exponent*1)*qmcol_vapp(base>0, log(base), 0);
    outVal = base^exponent;
end

function d_safeexp_d_x__ = d_safeexp_d_arg1__(x, maxslope)
    d_safeexp_d_x__ = 0;
    breakpoint = log(maxslope);
        d_safeexp_d_x__ = (exp(x*(x<=breakpoint))*0+(exp(x*(x<=breakpoint))*(x*0+1*(x<=breakpoint)))*(x<=breakpoint))+((x>breakpoint)*((maxslope*(1)))+0*(maxslope+maxslope*(x-breakpoint)));
    safeexp = exp(x*(x<=breakpoint))*(x<=breakpoint)+(x>breakpoint)*(maxslope+maxslope*(x-breakpoint));
end

function d_safeexp_d_maxslope__ = d_safeexp_d_arg2__(x, maxslope)
    d_safeexp_d_maxslope__ = 0;
        d_breakpoint_d_maxslope__ = (1/maxslope)*1;
    breakpoint = log(maxslope);
        d_safeexp_d_maxslope__ = (exp(x*(x<=breakpoint))*0+(exp(x*(x<=breakpoint))*(x*0))*(x<=breakpoint))+((x>breakpoint)*(1+(maxslope*(-d_breakpoint_d_maxslope__)+1*(x-breakpoint)))+0*(maxslope+maxslope*(x-breakpoint)));
    safeexp = exp(x*(x<=breakpoint))*(x<=breakpoint)+(x>breakpoint)*(maxslope+maxslope*(x-breakpoint));
end

function d_safelog_d_x__ = d_safelog_d_arg1__(x, smoothing)
    d_safelog_d_x__ = 0;
        d_safelog_d_x__ = (1/(smoothclip(x, smoothing)+1e-16))*(d_smoothclip_d_arg1__(x, smoothing)*1);
    safelog = log(smoothclip(x, smoothing)+1e-16);
end

function d_safelog_d_smoothing__ = d_safelog_d_arg2__(x, smoothing)
    d_safelog_d_smoothing__ = 0;
        d_safelog_d_smoothing__ = (1/(smoothclip(x, smoothing)+1e-16))*((d_smoothclip_d_arg2__(x, smoothing)*1));
    safelog = log(smoothclip(x, smoothing)+1e-16);
end

function d_safesinh_d_x__ = d_safesinh_d_arg1__(x, maxslope)
    d_safesinh_d_x__ = 0;
        d_safesinh_d_x__ = 0.5*(d_safeexp_d_arg1__(x, maxslope)*1-d_safeexp_d_arg1__(-x, maxslope)*-1);
    safesinh = 0.5*(safeexp(x, maxslope)-safeexp(-x, maxslope));
end

function d_safesinh_d_maxslope__ = d_safesinh_d_arg2__(x, maxslope)
    d_safesinh_d_maxslope__ = 0;
        d_safesinh_d_maxslope__ = 0.5*((d_safeexp_d_arg2__(x, maxslope)*1)-(d_safeexp_d_arg2__(-x, maxslope)*1));
    safesinh = 0.5*(safeexp(x, maxslope)-safeexp(-x, maxslope));
end

function d_safesqrt_d_x__ = d_safesqrt_d_arg1__(x, smoothing)
    d_safesqrt_d_x__ = 0;
        d_safesqrt_d_x__ = (1/(2*sqrt(smoothclip(x, smoothing)+1e-16)))*(d_smoothclip_d_arg1__(x, smoothing)*1);
    safesqrt = sqrt(smoothclip(x, smoothing)+1e-16);
end

function d_safesqrt_d_smoothing__ = d_safesqrt_d_arg2__(x, smoothing)
    d_safesqrt_d_smoothing__ = 0;
        d_safesqrt_d_smoothing__ = (1/(2*sqrt(smoothclip(x, smoothing)+1e-16)))*((d_smoothclip_d_arg2__(x, smoothing)*1));
    safesqrt = sqrt(smoothclip(x, smoothing)+1e-16);
end

function d_smoothabs_d_x__ = d_smoothabs_d_arg1__(x, smoothing)
    d_smoothabs_d_x__ = 0;
        d_smoothabs_d_x__ = (1/(2*sqrt(x*x+smoothing)))*((x*1+1*x));
    smoothabs = sqrt(x*x+smoothing)-sqrt(smoothing);
end

function d_smoothabs_d_smoothing__ = d_smoothabs_d_arg2__(x, smoothing)
    d_smoothabs_d_smoothing__ = 0;
        d_smoothabs_d_smoothing__ = (1/(2*sqrt(x*x+smoothing)))*(1)-(1/(2*sqrt(smoothing)))*1;
    smoothabs = sqrt(x*x+smoothing)-sqrt(smoothing);
end

function d_smoothclip_d_x__ = d_smoothclip_d_arg1__(x, smoothing)
    d_smoothclip_d_x__ = 0;
        d_smoothclip_d_x__ = 0.5*(d_smoothabs_d_arg1__(x, smoothing)*1+1);
    smoothclip = 0.5*(smoothabs(x, smoothing)+x);
end

function d_smoothclip_d_smoothing__ = d_smoothclip_d_arg2__(x, smoothing)
    d_smoothclip_d_smoothing__ = 0;
        d_smoothclip_d_smoothing__ = 0.5*((d_smoothabs_d_arg2__(x, smoothing)*1));
    smoothclip = 0.5*(smoothabs(x, smoothing)+x);
end

function d_smoothmax_d_a__ = d_smoothmax_d_arg1__(a, b, smoothing)
    d_smoothmax_d_a__ = 0;
        d_smoothmax_d_a__ = 0.5*((1)+d_smoothabs_d_arg1__(a-b, smoothing)*(1));
    smoothmax = 0.5*((a+b)+smoothabs(a-b, smoothing));
end

function d_smoothmax_d_b__ = d_smoothmax_d_arg2__(a, b, smoothing)
    d_smoothmax_d_b__ = 0;
        d_smoothmax_d_b__ = 0.5*((1)+d_smoothabs_d_arg1__(a-b, smoothing)*(-1));
    smoothmax = 0.5*((a+b)+smoothabs(a-b, smoothing));
end

function d_smoothmax_d_smoothing__ = d_smoothmax_d_arg3__(a, b, smoothing)
    d_smoothmax_d_smoothing__ = 0;
        d_smoothmax_d_smoothing__ = 0.5*((d_smoothabs_d_arg2__(a-b, smoothing)*1));
    smoothmax = 0.5*((a+b)+smoothabs(a-b, smoothing));
end

function d_smoothmin_d_a__ = d_smoothmin_d_arg1__(a, b, smoothing)
    d_smoothmin_d_a__ = 0;
        d_smoothmin_d_a__ = 0.5*((1)-d_smoothabs_d_arg1__(a-b, smoothing)*(1));
    smoothmin = 0.5*((a+b)-smoothabs(a-b, smoothing));
end

function d_smoothmin_d_b__ = d_smoothmin_d_arg2__(a, b, smoothing)
    d_smoothmin_d_b__ = 0;
        d_smoothmin_d_b__ = 0.5*((1)-d_smoothabs_d_arg1__(a-b, smoothing)*(-1));
    smoothmin = 0.5*((a+b)-smoothabs(a-b, smoothing));
end

function d_smoothmin_d_smoothing__ = d_smoothmin_d_arg3__(a, b, smoothing)
    d_smoothmin_d_smoothing__ = 0;
        d_smoothmin_d_smoothing__ = 0.5*(-(d_smoothabs_d_arg2__(a-b, smoothing)*1));
    smoothmin = 0.5*((a+b)-smoothabs(a-b, smoothing));
end

function d_smoothsign_d_x__ = d_smoothsign_d_arg1__(x, smoothing)
    d_smoothsign_d_x__ = 0;
        d_smoothsign_d_x__ = (2*(d_smoothstep_d_arg1__(x, smoothing)*1));
    smoothsign = 2*smoothstep(x, smoothing)-1;
end

function d_smoothsign_d_smoothing__ = d_smoothsign_d_arg2__(x, smoothing)
    d_smoothsign_d_smoothing__ = 0;
        d_smoothsign_d_smoothing__ = (2*(d_smoothstep_d_arg2__(x, smoothing)*1));
    smoothsign = 2*smoothstep(x, smoothing)-1;
end

function d_smoothstep_d_x__ = d_smoothstep_d_arg1__(x, smoothing)
    d_smoothstep_d_x__ = 0;
        d_smoothstep_d_x__ = d_dsmoothclip_d_arg1__(x, smoothing)*1;
    smoothstep = dsmoothclip(x, smoothing);
end

function d_smoothstep_d_smoothing__ = d_smoothstep_d_arg2__(x, smoothing)
    d_smoothstep_d_smoothing__ = 0;
        d_smoothstep_d_smoothing__ = d_dsmoothclip_d_arg2__(x, smoothing)*1;
    smoothstep = dsmoothclip(x, smoothing);
end

function d_smoothswitch_d_a__ = d_smoothswitch_d_arg1__(a, b, x, smoothing)
    d_smoothswitch_d_a__ = 0;
    oof = smoothstep(x, smoothing);
        d_smoothswitch_d_a__ = (1*(1-oof));
    smoothswitch = a*(1-oof)+b*oof;
end

function d_smoothswitch_d_b__ = d_smoothswitch_d_arg2__(a, b, x, smoothing)
    d_smoothswitch_d_b__ = 0;
    oof = smoothstep(x, smoothing);
        d_smoothswitch_d_b__ = (1*oof);
    smoothswitch = a*(1-oof)+b*oof;
end

function d_smoothswitch_d_x__ = d_smoothswitch_d_arg3__(a, b, x, smoothing)
    d_smoothswitch_d_x__ = 0;
        d_oof_d_x__ = d_smoothstep_d_arg1__(x, smoothing)*1;
    oof = smoothstep(x, smoothing);
        d_smoothswitch_d_x__ = (a*(-d_oof_d_x__))+(b*d_oof_d_x__);
    smoothswitch = a*(1-oof)+b*oof;
end

function d_smoothswitch_d_smoothing__ = d_smoothswitch_d_arg4__(a, b, x, smoothing)
    d_smoothswitch_d_smoothing__ = 0;
        d_oof_d_smoothing__ = d_smoothstep_d_arg2__(x, smoothing)*1;
    oof = smoothstep(x, smoothing);
        d_smoothswitch_d_smoothing__ = (a*(-d_oof_d_smoothing__))+(b*d_oof_d_smoothing__);
    smoothswitch = a*(1-oof)+b*oof;
end

function ddsmoothabs = ddsmoothabs(x, smoothing)
    ddsmoothabs = (-x/pow_vapp(smoothabs(x, smoothing), 2))*dsmoothabs(x, smoothing)+1/smoothabs(x, smoothing);
end

function ddsmoothclip = ddsmoothclip(x, smoothing)
    ddsmoothclip = 0.5*ddsmoothabs(x, smoothing);
end

function dsafeexp = dsafeexp(x, maxslope)
    breakpoint = log(maxslope);
    dsafeexp = exp(x*(x<=breakpoint))*(x<=breakpoint)+(x>breakpoint)*maxslope;
end

function dsafelog = dsafelog(x, smoothing)
    dsafelog = (1/(smoothclip(x, smoothing)+1e-16))*dsmoothclip(x, smoothing);
end

function dsafesinh = dsafesinh(x, maxslope)
    dsafesinh = 0.5*(dsafeexp(x, maxslope)-dsafeexp(-x, maxslope));
end

function dsafesqrt = dsafesqrt(x, smoothing)
    dsafesqrt = (0.5/sqrt(smoothclip(x, smoothing)+1e-16))*dsmoothclip(x, smoothing);
end

function dsmoothabs = dsmoothabs(x, smoothing)
    dsmoothabs = x/sqrt(x*x+smoothing);
end

function dsmoothclip = dsmoothclip(x, smoothing)
    dsmoothclip = 0.5*dsmoothabs(x, smoothing)+0.5;
end

function dsmoothmax_da = dsmoothmax_da(a, b, smoothing)
    dsmoothmax_da = 0.5*(1+dsmoothabs(a-b, smoothing));
end

function dsmoothmax_db = dsmoothmax_db(a, b, smoothing)
    dsmoothmax_db = 0.5*(1-dsmoothabs(a-b, smoothing));
end

function dsmoothmin_da = dsmoothmin_da(a, b, smoothing)
    dsmoothmin_da = 0.5*(1-dsmoothabs(a-b, smoothing));
end

function dsmoothmin_db = dsmoothmin_db(a, b, smoothing)
    dsmoothmin_db = 0.5*(1+dsmoothabs(a-b, smoothing));
end

function dsmoothsign = dsmoothsign(x, smoothing)
    dsmoothsign = 2*dsmoothstep(x, smoothing);
end

function dsmoothstep = dsmoothstep(x, smoothing)
    dsmoothstep = ddsmoothclip(x, smoothing);
end

function dsmoothswitch_da = dsmoothswitch_da(a, b, x, smoothing)
    oof = smoothstep(x, smoothing);
    dsmoothswitch_da = 1-oof;
end

function dsmoothswitch_db = dsmoothswitch_db(a, b, x, smoothing)
    oof = smoothstep(x, smoothing);
    dsmoothswitch_db = oof;
end

function dsmoothswitch_dx = dsmoothswitch_dx(a, b, x, smoothing)
    doof = dsmoothstep(x, smoothing);
    dsmoothswitch_dx = (-a+b)*doof;
end

function outVal = pow_vapp(base, exponent)
    outVal = base^exponent;
end

function safeexp = safeexp(x, maxslope)
    breakpoint = log(maxslope);
    safeexp = exp(x*(x<=breakpoint))*(x<=breakpoint)+(x>breakpoint)*(maxslope+maxslope*(x-breakpoint));
end

function safelog = safelog(x, smoothing)
    safelog = log(smoothclip(x, smoothing)+1e-16);
end

function safesinh = safesinh(x, maxslope)
    safesinh = 0.5*(safeexp(x, maxslope)-safeexp(-x, maxslope));
end

function safesqrt = safesqrt(x, smoothing)
    safesqrt = sqrt(smoothclip(x, smoothing)+1e-16);
end

function smoothabs = smoothabs(x, smoothing)
    smoothabs = sqrt(x*x+smoothing)-sqrt(smoothing);
end

function smoothclip = smoothclip(x, smoothing)
    smoothclip = 0.5*(smoothabs(x, smoothing)+x);
end

function smoothmax = smoothmax(a, b, smoothing)
    smoothmax = 0.5*((a+b)+smoothabs(a-b, smoothing));
end

function smoothmin = smoothmin(a, b, smoothing)
    smoothmin = 0.5*((a+b)-smoothabs(a-b, smoothing));
end

function smoothsign = smoothsign(x, smoothing)
    smoothsign = 2*smoothstep(x, smoothing)-1;
end

function smoothstep = smoothstep(x, smoothing)
    smoothstep = dsmoothclip(x, smoothing);
end

function smoothswitch = smoothswitch(a, b, x, smoothing)
    oof = smoothstep(x, smoothing);
    smoothswitch = a*(1-oof)+b*oof;
end
