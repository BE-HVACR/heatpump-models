within DXSystems.Reversible.WaterSource.Data;
record VSV024Hea =
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
          capFunT={0.6369418668344794,0.0011773226118348581,-0.0003098158717363097,
            0.019674059743868676,0.0002108676528905652,-0.0002625875140369248},
          capFunFF={0.9001443245567239,0.13524068062022757},
          capFunFFCon={0.9056535337599851,0.08969429167382033},
          EIRFunT={0.913354152917959,-0.018110759150034995,0.003745959479942453,
            0.0012328009902543707,-2.4732956316119792e-05,-0.001137755874324888},
          EIRFunFF={1.468708796653547,-0.6349411926750844},
          EIRFunFFCon={1.044766492540157,-0.04224845334846875},
          TConInMin=273.15 - 3.89,
          TConInMax=273.15 + 29.44,
          TEvaInMin=273.15 + 18.33,
          TEvaInMax=273.15 + 32.22,
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
