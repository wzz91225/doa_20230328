#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: peak_detector
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

class TEST_peak_detector(gr.top_block, Qt.QWidget):

    def __init__(self):
        gr.top_block.__init__(self, "peak_detector", catch_exceptions=True)
        Qt.QWidget.__init__(self)
        self.setWindowTitle("peak_detector")
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

        self.settings = Qt.QSettings("GNU Radio", "TEST_peak_detector")

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
        self.samp_rate = samp_rate = 32e3
        self.period_peak_detector = period_peak_detector = 1
        self.freq_sig_src = freq_sig_src = 1000
        self.fft_size = fft_size = 32768
        self.amp_sig_src = amp_sig_src = 1
        self.TH_Factor_Rise = TH_Factor_Rise = 0.25
        self.TH_Factor_Fall = TH_Factor_Fall = 0.4

        ##################################################
        # Blocks
        ##################################################
        self._period_peak_detector_range = Range(1e-1, 1e1, 1e-1, 1, 200)
        self._period_peak_detector_win = RangeWidget(self._period_peak_detector_range, self.set_period_peak_detector, "'period_peak_detector'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_grid_layout.addWidget(self._period_peak_detector_win, 2, 0, 1, 1)
        for r in range(2, 3):
            self.top_grid_layout.setRowStretch(r, 1)
        for c in range(0, 1):
            self.top_grid_layout.setColumnStretch(c, 1)
        self._freq_sig_src_range = Range(0, 1e4, 1, 1000, 200)
        self._freq_sig_src_win = RangeWidget(self._freq_sig_src_range, self.set_freq_sig_src, "'freq_sig_src'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_grid_layout.addWidget(self._freq_sig_src_win, 0, 0, 1, 1)
        for r in range(0, 1):
            self.top_grid_layout.setRowStretch(r, 1)
        for c in range(0, 1):
            self.top_grid_layout.setColumnStretch(c, 1)
        self._amp_sig_src_range = Range(0, 4, 1e-1, 1, 200)
        self._amp_sig_src_win = RangeWidget(self._amp_sig_src_range, self.set_amp_sig_src, "'amp_sig_src'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_grid_layout.addWidget(self._amp_sig_src_win, 1, 0, 1, 1)
        for r in range(1, 2):
            self.top_grid_layout.setRowStretch(r, 1)
        for c in range(0, 1):
            self.top_grid_layout.setColumnStretch(c, 1)
        self._TH_Factor_Rise_range = Range(1e-1, 1e1, 1e-2, 0.25, 200)
        self._TH_Factor_Rise_win = RangeWidget(self._TH_Factor_Rise_range, self.set_TH_Factor_Rise, "'TH_Factor_Rise'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._TH_Factor_Rise_win)
        self._TH_Factor_Fall_range = Range(1e-1, 1e1, 1e-2, 0.4, 200)
        self._TH_Factor_Fall_win = RangeWidget(self._TH_Factor_Fall_range, self.set_TH_Factor_Fall, "'TH_Factor_Fall'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._TH_Factor_Fall_win)
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

        self.top_grid_layout.addWidget(self._qtgui_sink_x_0_win, 3, 0, 1, 1)
        for r in range(3, 4):
            self.top_grid_layout.setRowStretch(r, 1)
        for c in range(0, 1):
            self.top_grid_layout.setColumnStretch(c, 1)
        self.qtgui_number_sink_1_0 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_NONE,
            1,
            None # parent
        )
        self.qtgui_number_sink_1_0.set_update_time(0.10)
        self.qtgui_number_sink_1_0.set_title("")

        labels = ["freq_err(%)", '', '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(1):
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
        self.top_grid_layout.addWidget(self._qtgui_number_sink_1_0_win, 7, 0, 1, 1)
        for r in range(7, 8):
            self.top_grid_layout.setRowStretch(r, 1)
        for c in range(0, 1):
            self.top_grid_layout.setColumnStretch(c, 1)
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
        self.top_grid_layout.addWidget(self._qtgui_number_sink_1_win, 6, 0, 1, 1)
        for r in range(6, 7):
            self.top_grid_layout.setRowStretch(r, 1)
        for c in range(0, 1):
            self.top_grid_layout.setColumnStretch(c, 1)
        self.qtgui_number_sink = qtgui.number_sink(
            gr.sizeof_char,
            0,
            qtgui.NUM_GRAPH_HORIZ,
            1,
            None # parent
        )
        self.qtgui_number_sink.set_update_time(0.10)
        self.qtgui_number_sink.set_title("")

        labels = ["peak_detected", '', '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(1):
            self.qtgui_number_sink.set_min(i, 0)
            self.qtgui_number_sink.set_max(i, 1)
            self.qtgui_number_sink.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink.set_label(i, labels[i])
            self.qtgui_number_sink.set_unit(i, units[i])
            self.qtgui_number_sink.set_factor(i, factor[i])

        self.qtgui_number_sink.enable_autoscale(False)
        self._qtgui_number_sink_win = sip.wrapinstance(self.qtgui_number_sink.qwidget(), Qt.QWidget)
        self.top_grid_layout.addWidget(self._qtgui_number_sink_win, 5, 0, 1, 1)
        for r in range(5, 6):
            self.top_grid_layout.setRowStretch(r, 1)
        for c in range(0, 1):
            self.top_grid_layout.setColumnStretch(c, 1)
        self.d20230402_hier_CenterFreqDetector_0 = d20230402_hier_CenterFreqDetector(
            TH_Factor_Fall=TH_Factor_Fall,
            TH_Factor_Rise=TH_Factor_Rise,
            fft_size=fft_size,
            period_peak_detector=1,
            samp_rate=samp_rate,
        )
        self.blocks_multiply_const_vxx_1 = blocks.multiply_const_ff((1e2/freq_sig_src))
        self.blocks_add_const_vxx_0 = blocks.add_const_ff((-freq_sig_src))
        self.blocks_abs_xx_0 = blocks.abs_ff(1)
        self.analog_sig_source_x_0 = analog.sig_source_c(samp_rate, analog.GR_COS_WAVE, freq_sig_src, amp_sig_src, 0, 0)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_sig_source_x_0, 0), (self.d20230402_hier_CenterFreqDetector_0, 0))
        self.connect((self.analog_sig_source_x_0, 0), (self.qtgui_sink_x_0, 0))
        self.connect((self.blocks_abs_xx_0, 0), (self.blocks_multiply_const_vxx_1, 0))
        self.connect((self.blocks_add_const_vxx_0, 0), (self.blocks_abs_xx_0, 0))
        self.connect((self.blocks_multiply_const_vxx_1, 0), (self.qtgui_number_sink_1_0, 0))
        self.connect((self.d20230402_hier_CenterFreqDetector_0, 1), (self.blocks_add_const_vxx_0, 0))
        self.connect((self.d20230402_hier_CenterFreqDetector_0, 0), (self.qtgui_number_sink, 0))
        self.connect((self.d20230402_hier_CenterFreqDetector_0, 3), (self.qtgui_number_sink_1, 1))
        self.connect((self.d20230402_hier_CenterFreqDetector_0, 1), (self.qtgui_number_sink_1, 0))


    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "TEST_peak_detector")
        self.settings.setValue("geometry", self.saveGeometry())
        self.stop()
        self.wait()

        event.accept()

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)
        self.d20230402_hier_CenterFreqDetector_0.set_samp_rate(self.samp_rate)
        self.qtgui_sink_x_0.set_frequency_range(0, self.samp_rate)

    def get_period_peak_detector(self):
        return self.period_peak_detector

    def set_period_peak_detector(self, period_peak_detector):
        self.period_peak_detector = period_peak_detector

    def get_freq_sig_src(self):
        return self.freq_sig_src

    def set_freq_sig_src(self, freq_sig_src):
        self.freq_sig_src = freq_sig_src
        self.analog_sig_source_x_0.set_frequency(self.freq_sig_src)
        self.blocks_add_const_vxx_0.set_k((-self.freq_sig_src))
        self.blocks_multiply_const_vxx_1.set_k((1e2/self.freq_sig_src))

    def get_fft_size(self):
        return self.fft_size

    def set_fft_size(self, fft_size):
        self.fft_size = fft_size
        self.d20230402_hier_CenterFreqDetector_0.set_fft_size(self.fft_size)

    def get_amp_sig_src(self):
        return self.amp_sig_src

    def set_amp_sig_src(self, amp_sig_src):
        self.amp_sig_src = amp_sig_src
        self.analog_sig_source_x_0.set_amplitude(self.amp_sig_src)

    def get_TH_Factor_Rise(self):
        return self.TH_Factor_Rise

    def set_TH_Factor_Rise(self, TH_Factor_Rise):
        self.TH_Factor_Rise = TH_Factor_Rise
        self.d20230402_hier_CenterFreqDetector_0.set_TH_Factor_Rise(self.TH_Factor_Rise)

    def get_TH_Factor_Fall(self):
        return self.TH_Factor_Fall

    def set_TH_Factor_Fall(self, TH_Factor_Fall):
        self.TH_Factor_Fall = TH_Factor_Fall
        self.d20230402_hier_CenterFreqDetector_0.set_TH_Factor_Fall(self.TH_Factor_Fall)




def main(top_block_cls=TEST_peak_detector, options=None):

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
