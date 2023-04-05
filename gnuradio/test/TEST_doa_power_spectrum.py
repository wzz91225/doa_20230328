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
from gnuradio import qtgui
from gnuradio.filter import firdes
import sip
from d20230402_hier_CenterFreqDetector import d20230402_hier_CenterFreqDetector  # grc-generated hier_block
from d20230403_hier_atan_epb import d20230403_hier_atan_epb  # grc-generated hier_block
from gnuradio import analog
from gnuradio import blocks
from gnuradio import gr
from gnuradio.fft import window
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import uhd
import time
from gnuradio.qtgui import Range, RangeWidget
from PyQt5 import QtCore



from gnuradio import qtgui

class TEST_doa_power_spectrum(gr.top_block, Qt.QWidget):

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

        self.settings = Qt.QSettings("GNU Radio", "TEST_doa_power_spectrum")

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
        self.TH_Factor_Rise = TH_Factor_Rise = 10
        self.RF_tx_center_freq = RF_tx_center_freq = 315e6
        self.samp_rate = samp_rate = 32e3
        self.period_peak_detector = period_peak_detector = 1
        self.freq_sig_src = freq_sig_src = 1000
        self.fft_size = fft_size = 65536
        self.amp_sig_src = amp_sig_src = 1
        self.TH_Factor_Fall = TH_Factor_Fall = TH_Factor_Rise
        self.RF_tx_gain = RF_tx_gain = 0
        self.RF_rx_center_freq = RF_rx_center_freq = RF_tx_center_freq
        self.RF_rx1_gain = RF_rx1_gain = 0
        self.RF_rx0_gain = RF_rx0_gain = 0

        ##################################################
        # Blocks
        ##################################################
        self._period_peak_detector_range = Range(1e-1, 1e1, 1e-1, 1, 200)
        self._period_peak_detector_win = RangeWidget(self._period_peak_detector_range, self.set_period_peak_detector, "'period_peak_detector'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._period_peak_detector_win)
        self._freq_sig_src_range = Range(0, 1e4, 1, 1000, 200)
        self._freq_sig_src_win = RangeWidget(self._freq_sig_src_range, self.set_freq_sig_src, "'freq_sig_src'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._freq_sig_src_win)
        self._amp_sig_src_range = Range(0, 4, 1e-1, 1, 200)
        self._amp_sig_src_win = RangeWidget(self._amp_sig_src_range, self.set_amp_sig_src, "'amp_sig_src'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._amp_sig_src_win)
        self._TH_Factor_Rise_range = Range(1e-1, 1e2, 1e-2, 10, 200)
        self._TH_Factor_Rise_win = RangeWidget(self._TH_Factor_Rise_range, self.set_TH_Factor_Rise, "'TH_Factor_Rise'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._TH_Factor_Rise_win)
        self._RF_tx_gain_range = Range(0, 100, 1e-1, 0, 200)
        self._RF_tx_gain_win = RangeWidget(self._RF_tx_gain_range, self.set_RF_tx_gain, "'RF_tx_gain'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._RF_tx_gain_win)
        self._RF_tx_center_freq_range = Range(1e6, 6e9, 1e6, 315e6, 200)
        self._RF_tx_center_freq_win = RangeWidget(self._RF_tx_center_freq_range, self.set_RF_tx_center_freq, "'RF_tx_center_freq'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._RF_tx_center_freq_win)
        self._RF_rx1_gain_range = Range(0, 100, 1e-1, 0, 200)
        self._RF_rx1_gain_win = RangeWidget(self._RF_rx1_gain_range, self.set_RF_rx1_gain, "'RF_rx1_gain'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._RF_rx1_gain_win)
        self._RF_rx0_gain_range = Range(0, 100, 1e-1, 0, 200)
        self._RF_rx0_gain_win = RangeWidget(self._RF_rx0_gain_range, self.set_RF_rx0_gain, "'RF_rx0_gain'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._RF_rx0_gain_win)
        self.uhd_usrp_source_0 = uhd.usrp_source(
            ",".join(("", '')),
            uhd.stream_args(
                cpu_format="fc32",
                args='',
                channels=list(range(0,2)),
            ),
        )
        self.uhd_usrp_source_0.set_samp_rate(samp_rate)
        self.uhd_usrp_source_0.set_time_unknown_pps(uhd.time_spec(0))

        self.uhd_usrp_source_0.set_center_freq(RF_rx_center_freq, 0)
        self.uhd_usrp_source_0.set_bandwidth(samp_rate, 0)
        self.uhd_usrp_source_0.set_gain(RF_rx0_gain, 0)

        self.uhd_usrp_source_0.set_center_freq(RF_rx_center_freq, 1)
        self.uhd_usrp_source_0.set_bandwidth(samp_rate, 1)
        self.uhd_usrp_source_0.set_gain(RF_rx1_gain, 1)
        self.uhd_usrp_sink_0 = uhd.usrp_sink(
            ",".join(("", '')),
            uhd.stream_args(
                cpu_format="fc32",
                args='',
                channels=list(range(0,1)),
            ),
            "",
        )
        self.uhd_usrp_sink_0.set_samp_rate(samp_rate)
        self.uhd_usrp_sink_0.set_time_unknown_pps(uhd.time_spec(0))

        self.uhd_usrp_sink_0.set_center_freq(RF_tx_center_freq, 0)
        self.uhd_usrp_sink_0.set_bandwidth(samp_rate, 0)
        self.uhd_usrp_sink_0.set_gain(RF_tx_gain, 0)
        self.qtgui_sink_x_0 = qtgui.sink_c(
            1024, #fftsize
            window.WIN_BLACKMAN_hARRIS, #wintype
            0, #fc
            samp_rate, #bw
            "", #name
            True, #plotfreq
            True, #plotwaterfall
            True, #plottime
            True, #plotconst
            None # parent
        )
        self.qtgui_sink_x_0.set_update_time(1.0/10)
        self._qtgui_sink_x_0_win = sip.wrapinstance(self.qtgui_sink_x_0.qwidget(), Qt.QWidget)

        self.qtgui_sink_x_0.enable_rf_freq(False)

        self.top_layout.addWidget(self._qtgui_sink_x_0_win)
        self.qtgui_number_sink_2_0_0 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_HORIZ,
            1,
            None # parent
        )
        self.qtgui_number_sink_2_0_0.set_update_time(0.10)
        self.qtgui_number_sink_2_0_0.set_title("")

        labels = ['DOA rms^1 (deg)', '', '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(1):
            self.qtgui_number_sink_2_0_0.set_min(i, -90)
            self.qtgui_number_sink_2_0_0.set_max(i, 90)
            self.qtgui_number_sink_2_0_0.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_2_0_0.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_2_0_0.set_label(i, labels[i])
            self.qtgui_number_sink_2_0_0.set_unit(i, units[i])
            self.qtgui_number_sink_2_0_0.set_factor(i, factor[i])

        self.qtgui_number_sink_2_0_0.enable_autoscale(False)
        self._qtgui_number_sink_2_0_0_win = sip.wrapinstance(self.qtgui_number_sink_2_0_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_2_0_0_win)
        self.qtgui_number_sink_2_0 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_HORIZ,
            1,
            None # parent
        )
        self.qtgui_number_sink_2_0.set_update_time(0.10)
        self.qtgui_number_sink_2_0.set_title("")

        labels = ['DOA rms^2 (deg)', '', '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(1):
            self.qtgui_number_sink_2_0.set_min(i, -90)
            self.qtgui_number_sink_2_0.set_max(i, 90)
            self.qtgui_number_sink_2_0.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_2_0.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_2_0.set_label(i, labels[i])
            self.qtgui_number_sink_2_0.set_unit(i, units[i])
            self.qtgui_number_sink_2_0.set_factor(i, factor[i])

        self.qtgui_number_sink_2_0.enable_autoscale(False)
        self._qtgui_number_sink_2_0_win = sip.wrapinstance(self.qtgui_number_sink_2_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_2_0_win)
        self.qtgui_number_sink_2 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_HORIZ,
            1,
            None # parent
        )
        self.qtgui_number_sink_2.set_update_time(0.10)
        self.qtgui_number_sink_2.set_title("")

        labels = ['DOA power (deg)', '', '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(1):
            self.qtgui_number_sink_2.set_min(i, -90)
            self.qtgui_number_sink_2.set_max(i, 90)
            self.qtgui_number_sink_2.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_2.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_2.set_label(i, labels[i])
            self.qtgui_number_sink_2.set_unit(i, units[i])
            self.qtgui_number_sink_2.set_factor(i, factor[i])

        self.qtgui_number_sink_2.enable_autoscale(False)
        self._qtgui_number_sink_2_win = sip.wrapinstance(self.qtgui_number_sink_2.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_2_win)
        self.qtgui_number_sink_1_0_0_0_0 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_NONE,
            2,
            None # parent
        )
        self.qtgui_number_sink_1_0_0_0_0.set_update_time(0.10)
        self.qtgui_number_sink_1_0_0_0_0.set_title("")

        labels = ["rms0^1", "rms1^1", '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(2):
            self.qtgui_number_sink_1_0_0_0_0.set_min(i, -1)
            self.qtgui_number_sink_1_0_0_0_0.set_max(i, 1)
            self.qtgui_number_sink_1_0_0_0_0.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_1_0_0_0_0.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_1_0_0_0_0.set_label(i, labels[i])
            self.qtgui_number_sink_1_0_0_0_0.set_unit(i, units[i])
            self.qtgui_number_sink_1_0_0_0_0.set_factor(i, factor[i])

        self.qtgui_number_sink_1_0_0_0_0.enable_autoscale(False)
        self._qtgui_number_sink_1_0_0_0_0_win = sip.wrapinstance(self.qtgui_number_sink_1_0_0_0_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_1_0_0_0_0_win)
        self.qtgui_number_sink_1_0_0_0 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_NONE,
            2,
            None # parent
        )
        self.qtgui_number_sink_1_0_0_0.set_update_time(0.10)
        self.qtgui_number_sink_1_0_0_0.set_title("")

        labels = ["rms0^2", "rms1^2", '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(2):
            self.qtgui_number_sink_1_0_0_0.set_min(i, -1)
            self.qtgui_number_sink_1_0_0_0.set_max(i, 1)
            self.qtgui_number_sink_1_0_0_0.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_1_0_0_0.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_1_0_0_0.set_label(i, labels[i])
            self.qtgui_number_sink_1_0_0_0.set_unit(i, units[i])
            self.qtgui_number_sink_1_0_0_0.set_factor(i, factor[i])

        self.qtgui_number_sink_1_0_0_0.enable_autoscale(False)
        self._qtgui_number_sink_1_0_0_0_win = sip.wrapinstance(self.qtgui_number_sink_1_0_0_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_1_0_0_0_win)
        self.qtgui_number_sink_1_0_0 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_NONE,
            2,
            None # parent
        )
        self.qtgui_number_sink_1_0_0.set_update_time(0.10)
        self.qtgui_number_sink_1_0_0.set_title("")

        labels = ["power0", "power1", '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(2):
            self.qtgui_number_sink_1_0_0.set_min(i, -1)
            self.qtgui_number_sink_1_0_0.set_max(i, 1)
            self.qtgui_number_sink_1_0_0.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_1_0_0.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_1_0_0.set_label(i, labels[i])
            self.qtgui_number_sink_1_0_0.set_unit(i, units[i])
            self.qtgui_number_sink_1_0_0.set_factor(i, factor[i])

        self.qtgui_number_sink_1_0_0.enable_autoscale(False)
        self._qtgui_number_sink_1_0_0_win = sip.wrapinstance(self.qtgui_number_sink_1_0_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_1_0_0_win)
        self.qtgui_number_sink_1_0 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_NONE,
            2,
            None # parent
        )
        self.qtgui_number_sink_1_0.set_update_time(0.10)
        self.qtgui_number_sink_1_0.set_title("")

        labels = ["freq_detected", "power_spectrum_detected(dB)", '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(2):
            self.qtgui_number_sink_1_0.set_min(i, -1)
            self.qtgui_number_sink_1_0.set_max(i, 1)
            self.qtgui_number_sink_1_0.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_1_0.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_1_0.set_label(i, labels[i])
            self.qtgui_number_sink_1_0.set_unit(i, units[i])
            self.qtgui_number_sink_1_0.set_factor(i, factor[i])

        self.qtgui_number_sink_1_0.enable_autoscale(False)
        self._qtgui_number_sink_1_0_win = sip.wrapinstance(self.qtgui_number_sink_1_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_1_0_win)
        self.qtgui_number_sink_1 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_NONE,
            2,
            None # parent
        )
        self.qtgui_number_sink_1.set_update_time(0.10)
        self.qtgui_number_sink_1.set_title("")

        labels = ["freq_detected", "power_spectrum_detected(dB)", '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(2):
            self.qtgui_number_sink_1.set_min(i, -1)
            self.qtgui_number_sink_1.set_max(i, 1)
            self.qtgui_number_sink_1.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_1.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_1.set_label(i, labels[i])
            self.qtgui_number_sink_1.set_unit(i, units[i])
            self.qtgui_number_sink_1.set_factor(i, factor[i])

        self.qtgui_number_sink_1.enable_autoscale(False)
        self._qtgui_number_sink_1_win = sip.wrapinstance(self.qtgui_number_sink_1.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_1_win)
        self.qtgui_freq_sink_x_0 = qtgui.freq_sink_c(
            1024, #size
            window.WIN_BLACKMAN_hARRIS, #wintype
            0, #fc
            samp_rate, #bw
            "", #name
            2,
            None # parent
        )
        self.qtgui_freq_sink_x_0.set_update_time(0.10)
        self.qtgui_freq_sink_x_0.set_y_axis((-140), 10)
        self.qtgui_freq_sink_x_0.set_y_label('Relative Gain', 'dB')
        self.qtgui_freq_sink_x_0.set_trigger_mode(qtgui.TRIG_MODE_FREE, 0.0, 0, "")
        self.qtgui_freq_sink_x_0.enable_autoscale(False)
        self.qtgui_freq_sink_x_0.enable_grid(False)
        self.qtgui_freq_sink_x_0.set_fft_average(1.0)
        self.qtgui_freq_sink_x_0.enable_axis_labels(True)
        self.qtgui_freq_sink_x_0.enable_control_panel(False)
        self.qtgui_freq_sink_x_0.set_fft_window_normalized(False)



        labels = ['', '', '', '', '',
            '', '', '', '', '']
        widths = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]
        colors = ["blue", "red", "green", "black", "cyan",
            "magenta", "yellow", "dark red", "dark green", "dark blue"]
        alphas = [1.0, 1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0, 1.0]

        for i in range(2):
            if len(labels[i]) == 0:
                self.qtgui_freq_sink_x_0.set_line_label(i, "Data {0}".format(i))
            else:
                self.qtgui_freq_sink_x_0.set_line_label(i, labels[i])
            self.qtgui_freq_sink_x_0.set_line_width(i, widths[i])
            self.qtgui_freq_sink_x_0.set_line_color(i, colors[i])
            self.qtgui_freq_sink_x_0.set_line_alpha(i, alphas[i])

        self._qtgui_freq_sink_x_0_win = sip.wrapinstance(self.qtgui_freq_sink_x_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_freq_sink_x_0_win)
        self.d20230403_hier_atan_epb_0_0_0 = d20230403_hier_atan_epb()
        self.d20230403_hier_atan_epb_0_0 = d20230403_hier_atan_epb()
        self.d20230403_hier_atan_epb_0 = d20230403_hier_atan_epb()
        self.d20230402_hier_CenterFreqDetector_0_0 = d20230402_hier_CenterFreqDetector(
            TH_Factor_Fall=TH_Factor_Fall,
            TH_Factor_Rise=TH_Factor_Rise,
            fft_size=fft_size,
            period_peak_detector=1,
            samp_rate=samp_rate,
        )
        self.d20230402_hier_CenterFreqDetector_0 = d20230402_hier_CenterFreqDetector(
            TH_Factor_Fall=TH_Factor_Fall,
            TH_Factor_Rise=TH_Factor_Rise,
            fft_size=fft_size,
            period_peak_detector=1,
            samp_rate=samp_rate,
        )
        self.blocks_rms_xx_1 = blocks.rms_cf(0.0001)
        self.blocks_rms_xx_0 = blocks.rms_cf(0.0001)
        self.blocks_null_sink_1 = blocks.null_sink(gr.sizeof_char*1)
        self.blocks_null_sink_0 = blocks.null_sink(gr.sizeof_char*1)
        self.blocks_multiply_xx_1 = blocks.multiply_vff(1)
        self.blocks_multiply_xx_0 = blocks.multiply_vff(1)
        self.blocks_divide_xx_0_0_0 = blocks.divide_ff(1)
        self.blocks_divide_xx_0_0 = blocks.divide_ff(1)
        self.blocks_divide_xx_0 = blocks.divide_ff(1)
        self.analog_sig_source_x_0 = analog.sig_source_c(samp_rate, analog.GR_COS_WAVE, freq_sig_src, amp_sig_src, 0, 0)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_sig_source_x_0, 0), (self.qtgui_sink_x_0, 0))
        self.connect((self.analog_sig_source_x_0, 0), (self.uhd_usrp_sink_0, 0))
        self.connect((self.blocks_divide_xx_0, 0), (self.d20230403_hier_atan_epb_0, 0))
        self.connect((self.blocks_divide_xx_0_0, 0), (self.d20230403_hier_atan_epb_0_0, 0))
        self.connect((self.blocks_divide_xx_0_0_0, 0), (self.d20230403_hier_atan_epb_0_0_0, 0))
        self.connect((self.blocks_multiply_xx_0, 0), (self.blocks_divide_xx_0_0, 0))
        self.connect((self.blocks_multiply_xx_0, 0), (self.qtgui_number_sink_1_0_0_0, 0))
        self.connect((self.blocks_multiply_xx_1, 0), (self.blocks_divide_xx_0_0, 1))
        self.connect((self.blocks_multiply_xx_1, 0), (self.qtgui_number_sink_1_0_0_0, 1))
        self.connect((self.blocks_rms_xx_0, 0), (self.blocks_divide_xx_0_0_0, 0))
        self.connect((self.blocks_rms_xx_0, 0), (self.blocks_multiply_xx_0, 1))
        self.connect((self.blocks_rms_xx_0, 0), (self.blocks_multiply_xx_0, 0))
        self.connect((self.blocks_rms_xx_0, 0), (self.qtgui_number_sink_1_0_0_0_0, 0))
        self.connect((self.blocks_rms_xx_1, 0), (self.blocks_divide_xx_0_0_0, 1))
        self.connect((self.blocks_rms_xx_1, 0), (self.blocks_multiply_xx_1, 0))
        self.connect((self.blocks_rms_xx_1, 0), (self.blocks_multiply_xx_1, 1))
        self.connect((self.blocks_rms_xx_1, 0), (self.qtgui_number_sink_1_0_0_0_0, 1))
        self.connect((self.d20230402_hier_CenterFreqDetector_0, 2), (self.blocks_divide_xx_0, 0))
        self.connect((self.d20230402_hier_CenterFreqDetector_0, 0), (self.blocks_null_sink_0, 0))
        self.connect((self.d20230402_hier_CenterFreqDetector_0, 1), (self.qtgui_number_sink_1, 0))
        self.connect((self.d20230402_hier_CenterFreqDetector_0, 3), (self.qtgui_number_sink_1, 1))
        self.connect((self.d20230402_hier_CenterFreqDetector_0, 2), (self.qtgui_number_sink_1_0_0, 0))
        self.connect((self.d20230402_hier_CenterFreqDetector_0_0, 2), (self.blocks_divide_xx_0, 1))
        self.connect((self.d20230402_hier_CenterFreqDetector_0_0, 0), (self.blocks_null_sink_1, 0))
        self.connect((self.d20230402_hier_CenterFreqDetector_0_0, 3), (self.qtgui_number_sink_1_0, 1))
        self.connect((self.d20230402_hier_CenterFreqDetector_0_0, 1), (self.qtgui_number_sink_1_0, 0))
        self.connect((self.d20230402_hier_CenterFreqDetector_0_0, 2), (self.qtgui_number_sink_1_0_0, 1))
        self.connect((self.d20230403_hier_atan_epb_0, 1), (self.qtgui_number_sink_2, 0))
        self.connect((self.d20230403_hier_atan_epb_0_0, 1), (self.qtgui_number_sink_2_0, 0))
        self.connect((self.d20230403_hier_atan_epb_0_0_0, 1), (self.qtgui_number_sink_2_0_0, 0))
        self.connect((self.uhd_usrp_source_0, 0), (self.blocks_rms_xx_0, 0))
        self.connect((self.uhd_usrp_source_0, 1), (self.blocks_rms_xx_1, 0))
        self.connect((self.uhd_usrp_source_0, 0), (self.d20230402_hier_CenterFreqDetector_0, 0))
        self.connect((self.uhd_usrp_source_0, 1), (self.d20230402_hier_CenterFreqDetector_0_0, 0))
        self.connect((self.uhd_usrp_source_0, 0), (self.qtgui_freq_sink_x_0, 0))
        self.connect((self.uhd_usrp_source_0, 1), (self.qtgui_freq_sink_x_0, 1))


    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "TEST_doa_power_spectrum")
        self.settings.setValue("geometry", self.saveGeometry())
        self.stop()
        self.wait()

        event.accept()

    def get_TH_Factor_Rise(self):
        return self.TH_Factor_Rise

    def set_TH_Factor_Rise(self, TH_Factor_Rise):
        self.TH_Factor_Rise = TH_Factor_Rise
        self.set_TH_Factor_Fall(self.TH_Factor_Rise)
        self.d20230402_hier_CenterFreqDetector_0.set_TH_Factor_Rise(self.TH_Factor_Rise)
        self.d20230402_hier_CenterFreqDetector_0_0.set_TH_Factor_Rise(self.TH_Factor_Rise)

    def get_RF_tx_center_freq(self):
        return self.RF_tx_center_freq

    def set_RF_tx_center_freq(self, RF_tx_center_freq):
        self.RF_tx_center_freq = RF_tx_center_freq
        self.set_RF_rx_center_freq(self.RF_tx_center_freq)
        self.uhd_usrp_sink_0.set_center_freq(self.RF_tx_center_freq, 0)

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)
        self.d20230402_hier_CenterFreqDetector_0.set_samp_rate(self.samp_rate)
        self.d20230402_hier_CenterFreqDetector_0_0.set_samp_rate(self.samp_rate)
        self.qtgui_freq_sink_x_0.set_frequency_range(0, self.samp_rate)
        self.qtgui_sink_x_0.set_frequency_range(0, self.samp_rate)
        self.uhd_usrp_sink_0.set_samp_rate(self.samp_rate)
        self.uhd_usrp_sink_0.set_bandwidth(self.samp_rate, 0)
        self.uhd_usrp_source_0.set_samp_rate(self.samp_rate)
        self.uhd_usrp_source_0.set_bandwidth(self.samp_rate, 0)
        self.uhd_usrp_source_0.set_bandwidth(self.samp_rate, 1)

    def get_period_peak_detector(self):
        return self.period_peak_detector

    def set_period_peak_detector(self, period_peak_detector):
        self.period_peak_detector = period_peak_detector

    def get_freq_sig_src(self):
        return self.freq_sig_src

    def set_freq_sig_src(self, freq_sig_src):
        self.freq_sig_src = freq_sig_src
        self.analog_sig_source_x_0.set_frequency(self.freq_sig_src)

    def get_fft_size(self):
        return self.fft_size

    def set_fft_size(self, fft_size):
        self.fft_size = fft_size
        self.d20230402_hier_CenterFreqDetector_0.set_fft_size(self.fft_size)
        self.d20230402_hier_CenterFreqDetector_0_0.set_fft_size(self.fft_size)

    def get_amp_sig_src(self):
        return self.amp_sig_src

    def set_amp_sig_src(self, amp_sig_src):
        self.amp_sig_src = amp_sig_src
        self.analog_sig_source_x_0.set_amplitude(self.amp_sig_src)

    def get_TH_Factor_Fall(self):
        return self.TH_Factor_Fall

    def set_TH_Factor_Fall(self, TH_Factor_Fall):
        self.TH_Factor_Fall = TH_Factor_Fall
        self.d20230402_hier_CenterFreqDetector_0.set_TH_Factor_Fall(self.TH_Factor_Fall)
        self.d20230402_hier_CenterFreqDetector_0_0.set_TH_Factor_Fall(self.TH_Factor_Fall)

    def get_RF_tx_gain(self):
        return self.RF_tx_gain

    def set_RF_tx_gain(self, RF_tx_gain):
        self.RF_tx_gain = RF_tx_gain
        self.uhd_usrp_sink_0.set_gain(self.RF_tx_gain, 0)

    def get_RF_rx_center_freq(self):
        return self.RF_rx_center_freq

    def set_RF_rx_center_freq(self, RF_rx_center_freq):
        self.RF_rx_center_freq = RF_rx_center_freq
        self.uhd_usrp_source_0.set_center_freq(self.RF_rx_center_freq, 0)
        self.uhd_usrp_source_0.set_center_freq(self.RF_rx_center_freq, 1)

    def get_RF_rx1_gain(self):
        return self.RF_rx1_gain

    def set_RF_rx1_gain(self, RF_rx1_gain):
        self.RF_rx1_gain = RF_rx1_gain
        self.uhd_usrp_source_0.set_gain(self.RF_rx1_gain, 1)

    def get_RF_rx0_gain(self):
        return self.RF_rx0_gain

    def set_RF_rx0_gain(self, RF_rx0_gain):
        self.RF_rx0_gain = RF_rx0_gain
        self.uhd_usrp_source_0.set_gain(self.RF_rx0_gain, 0)




def main(top_block_cls=TEST_doa_power_spectrum, options=None):

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
