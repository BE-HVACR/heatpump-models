within DXSystems.Reversible.WaterSource.Data;
record VSV024Coo3 =
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
          capFunT={0.4861255666760971,0.03002335398147802,-0.00021279533247713046,
            -0.0013756130911607226,-2.066990592237827e-05,-0.00019936826894468405},
          capFunFF={0.7685598823721829,0.31498953054702844},
          capFunFFCon={0.9856340780885993,0.016423336027544522},
          EIRFunT={0.6438101732437533,-0.02368485320203061,
            0.00047406260347688926,0.016757849333067214,0.00031069058049663586,
            -0.0004540361091002112},
          EIRFunFF={1.0451935090087352,-0.0614958411872731},
          EIRFunFFCon={1.1154782811513448,-0.13223908369989287},
          TConInMin=273.15 + 7.2,
          TConInMax=273.15 + 48.8,
          TEvaInMin=273.15 + 10,
          TEvaInMax=273.15 + 25.56,
          ffMin=0.875,
          ffMax=1.125,
          ffConMin=0.875,
          ffConMax=1.125))}) "VSV024Coo"
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
