within DXSystems.Reversible.WaterSource.Data;
record VSV024Hea2 =
  DXSystems.Cooling.WaterSource.Data.Generic.DXCoil (
    nSta=1,
    minSpeRat=0.31,
    sta={DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=3000,
        nomVal=
          DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=8880,
          COP_nominal=6.1,
          SHR_nominal=1,
          m_flow_nominal=1.2*0.4389,
          mCon_flow_nominal=1000*0.00039),
        perCur=
          DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.45925536518299437,-0.0013050734028837387,-1.9016543203276734e-05,
            0.019007443407759506,4.27609060417566e-05,-0.00014476326504573624},
          capFunFF={0.8935464784714185,0.1463060691424797},
          capFunFFCon={0.921263331209476,0.07482000317225788},
          EIRFunT={0.7265333330040449,0.02699495099091462,0.0002512997610790123,
            -0.01599841860831001,0.00032480273429471906,-0.0005880564607380053},
          EIRFunFF={1.3971413743639551,-0.5455600880724918},
          EIRFunFFCon={1.0508215548811073,-0.04808022202954253},
          TConInMin=273.15 - 3.89,
          TConInMax=273.15 + 29.44,
          TEvaInMin=273.15 + 18.33,
          TEvaInMax=273.15 + 32.22,
          ffMin=0.875,
          ffMax=1.125,
          ffConMin=0.875,
          ffConMax=1.125))}) "VSV024Hea"
                            annotation (
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
