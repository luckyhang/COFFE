.TITLE General BLE output

********************************************************************************
** Include libraries, parameters and other
********************************************************************************

.LIB "../includes.l" INCLUDES

********************************************************************************
** Setup and input
********************************************************************************

.TRAN 1p 4n SWEEP DATA=sweep_data
.OPTIONS BRIEF=1

* Input signal
VIN n_in gnd PULSE (0 supply_v 0 0 0 2n 4n)

* Power rail for the circuit under test.
* This allows us to measure power of a circuit under test without measuring the power of wave shaping and load circuitry.
V_GENERAL_OUTPUT vdd_general_output gnd supply_v

********************************************************************************
** Measurement
********************************************************************************

* inv_general_ble_output_1 delay
.MEASURE TRAN meas_inv_general_ble_output_1_tfall TRIG V(n_1_1) VAL='supply_v/2' RISE=1
+    TARG V(Xlut_output_load.Xble_outputs.Xgeneral_ble_output_1.n_2_1) VAL='supply_v/2' FALL=1
.MEASURE TRAN meas_inv_general_ble_output_1_trise TRIG V(n_1_1) VAL='supply_v/2' FALL=1
+    TARG V(Xlut_output_load.Xble_outputs.Xgeneral_ble_output_1.n_2_1) VAL='supply_v/2' RISE=1

* inv_general_ble_output_2 delays
.MEASURE TRAN meas_inv_general_ble_output_2_tfall TRIG V(n_1_1) VAL='supply_v/2' FALL=1
+    TARG V(Xgeneral_ble_output_load.n_meas_point) VAL='supply_v/2' FALL=1
.MEASURE TRAN meas_inv_general_ble_output_2_trise TRIG V(n_1_1) VAL='supply_v/2' RISE=1
+    TARG V(Xgeneral_ble_output_load.n_meas_point) VAL='supply_v/2' RISE=1

* Total delays
.MEASURE TRAN meas_total_tfall TRIG V(n_1_1) VAL='supply_v/2' FALL=1
+    TARG V(Xgeneral_ble_output_load.n_meas_point) VAL='supply_v/2' FALL=1
.MEASURE TRAN meas_total_trise TRIG V(n_1_1) VAL='supply_v/2' RISE=1
+    TARG V(Xgeneral_ble_output_load.n_meas_point) VAL='supply_v/2' RISE=1

.MEASURE TRAN meas_logic_low_voltage FIND V(n_general_out) AT=3n

* Measure the power required to propagate a rise and a fall transition through the subcircuit at 250MHz.
.MEASURE TRAN meas_current INTEGRAL I(V_GENERAL_OUTPUT) FROM=0ns TO=4ns
.MEASURE TRAN meas_avg_power PARAM = '-((meas_current)/4n)*supply_v'

********************************************************************************
** Circuit
********************************************************************************

Xlut n_in n_1_1 vdd vdd vdd vdd vdd vdd vdd gnd lut

Xlut_output_load n_1_1 n_local_out n_general_out vsram vsram_n vdd gnd vdd vdd_general_output lut_output_load

Xgeneral_ble_output_load n_general_out n_hang1 vsram vsram_n vdd gnd general_ble_output_load
.END