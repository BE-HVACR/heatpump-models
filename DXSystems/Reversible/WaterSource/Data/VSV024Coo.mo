within DXSystems.Reversible.WaterSource.Data;
record VSV024Coo =
  DXSystems.Cooling.WaterSource.Data.Generic.DXCoil (
    nSta=1,
    minSpeRat=0.31,
    sta={DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=3000,
        nomVal=
          DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-7210,
          COP_nominal=5.4,
          SHR_nominal=0.82,
          m_flow_nominal=1.2*0.4389,
          mCon_flow_nominal=1000*0.00039),
        perCur=
          DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.6369488608347195,0.02947970305914937,
            3.8142598111833636e-05,-0.0011039523392953198,-4.298284170342427e-05,
            -0.00020897055595785053},
          capFunFF={0.7490890679562445,0.34112670044793736},
          capFunFFCon={0.9811357846103516,0.02156602687667994},
          EIRFunT={0.73362259986729,-0.025898803180744723,0.0004997066684203221,
            0.016803751649986678,0.00031473640676349184,-0.00046946481780783106},
          EIRFunFF={1.225527664075327,-0.3066095497468709},
          EIRFunFFCon={1.1315694439063082,-0.15059824380321607},
          TConInMin=273.15 + 7.2,
          TConInMax=273.15 + 48.8,
          TEvaInMin=273.15 + 10,
          TEvaInMax=273.15 + 25.56,
          ffMin=0.875,
          ffMax=1.125,
          ffConMin=0.875,
          ffConMax=1.125))})
          "VSV024Coo"       annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Goodman CPC060,              !- Name
    CoolingCoilAvailSched,       !- Availability Schedule Name
    17427.55,                    !- Rated Total Cooling Capacity {W}
    0.72,                        !- Rated Sensible Heat Ratio
    3.95,                        !- Rated COP
    0.944,                       !- Rated Air Flow Rate {m3/s}
    ,                            !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,          !- Air Inlet Node Name
    DXCoilAirOutletNode,         !- Air Outlet Node Name
    Goodman CPC060 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Goodman CPC060 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Goodman CPC060 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Goodman CPC060 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Goodman CPC060 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
