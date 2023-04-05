#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: Not titled yet
# Author: zzaw
# GNU Radio version: 3.10.4.0

from packaging.version import Version as StrictVersion

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print("Warning: failed to XInitThreads()")

import os
import sys
sys.path.append(os.environ.get('GRC_HIER_PATH', os.path.expanduser('~/.grc_gnuradio')))

from PyQt5 import Qt
from PyQt5.QtCore import QObject, pyqtSlot
from gnuradio import qtgui
from gnuradio.filter import firdes
import sip
from d20230320_hier_complex2float import d20230320_hier_complex2float  # grc-generated hier_block
from gnuradio import analog
from gnuradio import blocks
from gnuradio import gr
from gnuradio.fft import window
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio.qtgui import Range, RangeWidget
from PyQt5 import QtCore



from gnuradio import qtgui

class TEST_complex2float(gr.top_block, Qt.QWidget):

    def __init__(self):
        gr.top_block.__init__(self, "Not titled yet", catch_exceptions=True)
        Qt.QWidget.__init__(self)
        self.setWindowTitle("Not titled yet")
        qtgui.util.check_set_qss()
        try:
            self.setWindowIcon(Qt.QIcon.fromTheme('gnuradio-grc'))
        except:
            pass
        self.top_scroll_layout = Qt.QVBoxLayout()
        self.setLayout(self.top_scroll_layout)
        self.top_scroll = Qt.QScrollArea()
        self.top_scroll.setFrameStyle(Qt.QFrame.NoFrame)
        self.top_scroll_layout.addWidget(self.top_scroll)
        self.top_scroll.setWidgetResizable(True)
        self.top_widget = Qt.QWidget()
        self.top_scroll.setWidget(self.top_widget)
        self.top_layout = Qt.QVBoxLayout(self.top_widget)
        self.top_grid_layout = Qt.QGridLayout()
        self.top_layout.addLayout(self.top_grid_layout)

        self.settings = Qt.QSettings("GNU Radio", "TEST_complex2float")

        try:
            if StrictVersion(Qt.qVersion()) < StrictVersion("5.0.0"):
                self.restoreGeometry(self.settings.value("geometry").toByteArray())
            else:
                self.restoreGeometry(self.settings.value("geometry"))
        except:
            pass

        ##################################################
        # Variables
        ##################################################
        self.waveform = waveform = 101
        self.samp_rate = samp_rate = 32000
        self.pi = pi = 3.141592653589793238462643
        self.amplitude = amplitude = 1

        ##################################################
        # Blocks
        ##################################################
        # Create the options list
        self._waveform_options = [101, 102, 103, 104, 105]
        # Create the labels list
        self._waveform_labels = ['GR_SIN_WAVE', 'GR_COS_WAVE', 'GR_SQR_WAVE', 'GR_TRI_WAVE', 'GR_SAW_WAVE']
        # Create the combo box
        self._waveform_tool_bar = Qt.QToolBar(self)
        self._waveform_tool_bar.addWidget(Qt.QLabel("'waveform'" + ": "))
        self._waveform_combo_box = Qt.QComboBox()
        self._waveform_tool_bar.addWidget(self._waveform_combo_box)
        for _label in self._waveform_labels: self._waveform_combo_box.addItem(_label)
        self._waveform_callback = lambda i: Qt.QMetaObject.invokeMethod(self._waveform_combo_box, "setCurrentIndex", Qt.Q_ARG("int", self._waveform_options.index(i)))
        self._waveform_callback(self.waveform)
        self._waveform_combo_box.currentIndexChanged.connect(
            lambda i: self.set_waveform(self._waveform_options[i]))
        # Create the radio buttons
        self.top_layout.addWidget(self._waveform_tool_bar)
        self._amplitude_range = Range(0, 2, 1e-2, 1, 200)
        self._amplitude_win = RangeWidget(self._amplitude_range, self.set_amplitude, "'amplitude'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._amplitude_win)
        self.sig_src = analog.sig_source_c(samp_rate, waveform, 1000, amplitude, 0, 0)
        self.qtgui_time_sink_x_0 = qtgui.time_sink_f(
            1024, #size
            samp_rate, #samp_rate
            "", #name
            9, #number of inputs
            None # parent
        )
        self.qtgui_time_sink_x_0.set_update_time(0.10)
        self.qtgui_time_sink_x_0.set_y_axis(-1, 1)

        self.qtgui_time_sink_x_0.set_y_label('Amplitude', "")

        self.qtgui_time_sink_x_0.enable_tags(True)
        self.qtgui_time_sink_x_0.set_trigger_mode(qtgui.TRIG_MODE_AUTO, qtgui.TRIG_SLOPE_POS, 0.0, 0, 0, "")
        self.qtgui_time_sink_x_0.enable_autoscale(True)
        self.qtgui_time_sink_x_0.enable_grid(True)
        self.qtgui_time_sink_x_0.enable_axis_labels(True)
        self.qtgui_time_sink_x_0.enable_control_panel(True)
        self.qtgui_time_sink_x_0.enable_stem_plot(False)


        labels = ['real', 'imag', 'mag', 'mag^2', 'real',
            'rms', 'OOT_complex2float', 'real+imag', 'real^2+imag^2', 'Signal 10']
        widths = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]
        colors = ['blue', 'red', 'green', 'black', 'cyan',
            'magenta', 'yellow', 'dark red', 'dark green', 'dark blue']
        alphas = [1.0, 1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0, 1.0]
        styles = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]
        markers = [-1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1]


        for i in range(9):
            if len(labels[i]) == 0:
                self.qtgui_time_sink_x_0.set_line_label(i, "Data {0}".format(i))
            else:
                self.qtgui_time_sink_x_0.set_line_label(i, labels[i])
            self.qtgui_time_sink_x_0.set_line_width(i, widths[i])
            self.qtgui_time_sink_x_0.set_line_color(i, colors[i])
            self.qtgui_time_sink_x_0.set_line_style(i, styles[i])
            self.qtgui_time_sink_x_0.set_line_marker(i, markers[i])
            self.qtgui_time_sink_x_0.set_line_alpha(i, alphas[i])

        self._qtgui_time_sink_x_0_win = sip.wrapinstance(self.qtgui_time_sink_x_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_time_sink_x_0_win)
        self.d20230320_hier_complex2float_0 = d20230320_hier_complex2float()
        self.blocks_rms_xx_0 = blocks.rms_cf(0.0001)
        self.blocks_multiply_xx_0_0 = blocks.multiply_vff(1)
        self.blocks_multiply_xx_0 = blocks.multiply_vff(1)
        self.blocks_complex_to_real_0 = blocks.complex_to_real(1)
        self.blocks_complex_to_mag_squared_0 = blocks.complex_to_mag_squared(1)
        self.blocks_complex_to_mag_0 = blocks.complex_to_mag(1)
        self.blocks_complex_to_float_0 = blocks.complex_to_float(1)
        self.blocks_add_xx_0_0 = blocks.add_vff(1)
        self.blocks_add_xx_0 = blocks.add_vff(1)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_add_xx_0, 0), (self.qtgui_time_sink_x_0, 7))
        self.connect((self.blocks_add_xx_0_0, 0), (self.qtgui_time_sink_x_0, 8))
        self.connect((self.blocks_complex_to_float_0, 0), (self.blocks_add_xx_0, 0))
        self.connect((self.blocks_complex_to_float_0, 1), (self.blocks_add_xx_0, 1))
        self.connect((self.blocks_complex_to_float_0, 0), (self.blocks_multiply_xx_0, 0))
        self.connect((self.blocks_complex_to_float_0, 0), (self.blocks_multiply_xx_0, 1))
        self.connect((self.blocks_complex_to_float_0, 1), (self.blocks_multiply_xx_0_0, 0))
        self.connect((self.blocks_complex_to_float_0, 1), (self.blocks_multiply_xx_0_0, 1))
        self.connect((self.blocks_complex_to_float_0, 1), (self.qtgui_time_sink_x_0, 1))
        self.connect((self.blocks_complex_to_float_0, 0), (self.qtgui_time_sink_x_0, 0))
        self.connect((self.blocks_complex_to_mag_0, 0), (self.qtgui_time_sink_x_0, 2))
        self.connect((self.blocks_complex_to_mag_squared_0, 0), (self.qtgui_time_sink_x_0, 3))
        self.connect((self.blocks_complex_to_real_0, 0), (self.qtgui_time_sink_x_0, 4))
        self.connect((self.blocks_multiply_xx_0, 0), (self.blocks_add_xx_0_0, 0))
        self.connect((self.blocks_multiply_xx_0_0, 0), (self.blocks_add_xx_0_0, 1))
        self.connect((self.blocks_rms_xx_0, 0), (self.qtgui_time_sink_x_0, 5))
        self.connect((self.d20230320_hier_complex2float_0, 0), (self.qtgui_time_sink_x_0, 6))
        self.connect((self.sig_src, 0), (self.blocks_complex_to_float_0, 0))
        self.connect((self.sig_src, 0), (self.blocks_complex_to_mag_0, 0))
        self.connect((self.sig_src, 0), (self.blocks_complex_to_mag_squared_0, 0))
        self.connect((self.sig_src, 0), (self.blocks_complex_to_real_0, 0))
        self.connect((self.sig_src, 0), (self.blocks_rms_xx_0, 0))
        self.connect((self.sig_src, 0), (self.d20230320_hier_complex2float_0, 0))


    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "TEST_complex2float")
        self.settings.setValue("geometry", self.saveGeometry())
        self.stop()
        self.wait()

        event.accept()

    def get_waveform(self):
        return self.waveform

    def set_waveform(self, waveform):
        self.waveform = waveform
        self._waveform_callback(self.waveform)
        self.sig_src.set_waveform(self.waveform)

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.qtgui_time_sink_x_0.set_samp_rate(self.samp_rate)
        self.sig_src.set_sampling_freq(self.samp_rate)

    def get_pi(self):
        return self.pi

    def set_pi(self, pi):
        self.pi = pi

    def get_amplitude(self):
        return self.amplitude

    def set_amplitude(self, amplitude):
        self.amplitude = amplitude
        self.sig_src.set_amplitude(self.amplitude)




def main(top_block_cls=TEST_complex2float, options=None):

    if StrictVersion("4.5.0") <= StrictVersion(Qt.qVersion()) < StrictVersion("5.0.0"):
        style = gr.prefs().get_string('qtgui', 'style', 'raster')
        Qt.QApplication.setGraphicsSystem(style)
    qapp = Qt.QApplication(sys.argv)

    tb = top_block_cls()

    tb.start()

    tb.show()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        Qt.QApplication.quit()

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    timer = Qt.QTimer()
    timer.start(500)
    timer.timeout.connect(lambda: None)

    qapp.exec_()

if __name__ == '__main__':
    main()
