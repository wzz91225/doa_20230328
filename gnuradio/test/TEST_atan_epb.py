#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: atan (epb)
# Author: zzaw
# Description: [-pi/2, pi/2]
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
from gnuradio import eng_notation
from gnuradio import qtgui
import sip
from d20230403_hier_atan_epb import d20230403_hier_atan_epb  # grc-generated hier_block
from d20230404_hier_atan2_epb import d20230404_hier_atan2_epb  # grc-generated hier_block
from gnuradio import analog
from gnuradio import gr
from gnuradio.filter import firdes
from gnuradio.fft import window
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio.qtgui import Range, RangeWidget
from PyQt5 import QtCore



from gnuradio import qtgui

class TEST_atan_epb(gr.top_block, Qt.QWidget):

    def __init__(self):
        gr.top_block.__init__(self, "atan (epb)", catch_exceptions=True)
        Qt.QWidget.__init__(self)
        self.setWindowTitle("atan (epb)")
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

        self.settings = Qt.QSettings("GNU Radio", "TEST_atan_epb")

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
        self.value_y = value_y = 1
        self.value_x = value_x = 1
        self.value = value = 1
        self.samp_rate = samp_rate = 32000
        self.pi = pi = 3.141592653589793238462643

        ##################################################
        # Blocks
        ##################################################
        self._value_y_tool_bar = Qt.QToolBar(self)
        self._value_y_tool_bar.addWidget(Qt.QLabel("'value_y'" + ": "))
        self._value_y_line_edit = Qt.QLineEdit(str(self.value_y))
        self._value_y_tool_bar.addWidget(self._value_y_line_edit)
        self._value_y_line_edit.returnPressed.connect(
            lambda: self.set_value_y(eng_notation.str_to_num(str(self._value_y_line_edit.text()))))
        self.top_layout.addWidget(self._value_y_tool_bar)
        self._value_x_tool_bar = Qt.QToolBar(self)
        self._value_x_tool_bar.addWidget(Qt.QLabel("'value_x'" + ": "))
        self._value_x_line_edit = Qt.QLineEdit(str(self.value_x))
        self._value_x_tool_bar.addWidget(self._value_x_line_edit)
        self._value_x_line_edit.returnPressed.connect(
            lambda: self.set_value_x(eng_notation.str_to_num(str(self._value_x_line_edit.text()))))
        self.top_layout.addWidget(self._value_x_tool_bar)
        self._value_range = Range(-1e2, 1e2, 1e-1, 1, 200)
        self._value_win = RangeWidget(self._value_range, self.set_value, "'value'", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._value_win)
        self.qtgui_number_sink_0_1 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_HORIZ,
            1,
            None # parent
        )
        self.qtgui_number_sink_0_1.set_update_time(0.10)
        self.qtgui_number_sink_0_1.set_title("")

        labels = ['', '', '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(1):
            self.qtgui_number_sink_0_1.set_min(i, -pi)
            self.qtgui_number_sink_0_1.set_max(i, pi)
            self.qtgui_number_sink_0_1.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_0_1.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_0_1.set_label(i, labels[i])
            self.qtgui_number_sink_0_1.set_unit(i, units[i])
            self.qtgui_number_sink_0_1.set_factor(i, factor[i])

        self.qtgui_number_sink_0_1.enable_autoscale(False)
        self._qtgui_number_sink_0_1_win = sip.wrapinstance(self.qtgui_number_sink_0_1.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_0_1_win)
        self.qtgui_number_sink_0_0_0 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_HORIZ,
            1,
            None # parent
        )
        self.qtgui_number_sink_0_0_0.set_update_time(0.10)
        self.qtgui_number_sink_0_0_0.set_title("")

        labels = ['', '', '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(1):
            self.qtgui_number_sink_0_0_0.set_min(i, -180)
            self.qtgui_number_sink_0_0_0.set_max(i, 180)
            self.qtgui_number_sink_0_0_0.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_0_0_0.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_0_0_0.set_label(i, labels[i])
            self.qtgui_number_sink_0_0_0.set_unit(i, units[i])
            self.qtgui_number_sink_0_0_0.set_factor(i, factor[i])

        self.qtgui_number_sink_0_0_0.enable_autoscale(False)
        self._qtgui_number_sink_0_0_0_win = sip.wrapinstance(self.qtgui_number_sink_0_0_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_0_0_0_win)
        self.qtgui_number_sink_0_0 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_HORIZ,
            1,
            None # parent
        )
        self.qtgui_number_sink_0_0.set_update_time(0.10)
        self.qtgui_number_sink_0_0.set_title("")

        labels = ['', '', '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(1):
            self.qtgui_number_sink_0_0.set_min(i, -180)
            self.qtgui_number_sink_0_0.set_max(i, 180)
            self.qtgui_number_sink_0_0.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_0_0.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_0_0.set_label(i, labels[i])
            self.qtgui_number_sink_0_0.set_unit(i, units[i])
            self.qtgui_number_sink_0_0.set_factor(i, factor[i])

        self.qtgui_number_sink_0_0.enable_autoscale(False)
        self._qtgui_number_sink_0_0_win = sip.wrapinstance(self.qtgui_number_sink_0_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_0_0_win)
        self.qtgui_number_sink_0 = qtgui.number_sink(
            gr.sizeof_float,
            0,
            qtgui.NUM_GRAPH_HORIZ,
            1,
            None # parent
        )
        self.qtgui_number_sink_0.set_update_time(0.10)
        self.qtgui_number_sink_0.set_title("")

        labels = ['', '', '', '', '',
            '', '', '', '', '']
        units = ['', '', '', '', '',
            '', '', '', '', '']
        colors = [("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"),
            ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black"), ("black", "black")]
        factor = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]

        for i in range(1):
            self.qtgui_number_sink_0.set_min(i, -pi)
            self.qtgui_number_sink_0.set_max(i, pi)
            self.qtgui_number_sink_0.set_color(i, colors[i][0], colors[i][1])
            if len(labels[i]) == 0:
                self.qtgui_number_sink_0.set_label(i, "Data {0}".format(i))
            else:
                self.qtgui_number_sink_0.set_label(i, labels[i])
            self.qtgui_number_sink_0.set_unit(i, units[i])
            self.qtgui_number_sink_0.set_factor(i, factor[i])

        self.qtgui_number_sink_0.enable_autoscale(False)
        self._qtgui_number_sink_0_win = sip.wrapinstance(self.qtgui_number_sink_0.qwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_number_sink_0_win)
        self.d20230404_hier_atan2_epb_0 = d20230404_hier_atan2_epb()
        self.d20230403_hier_atan_epb_0 = d20230403_hier_atan_epb()
        self.analog_const_source_x_0_1 = analog.sig_source_f(0, analog.GR_CONST_WAVE, 0, 0, value_y)
        self.analog_const_source_x_0_0 = analog.sig_source_f(0, analog.GR_CONST_WAVE, 0, 0, value_x)
        self.analog_const_source_x_0 = analog.sig_source_f(0, analog.GR_CONST_WAVE, 0, 0, value)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_const_source_x_0, 0), (self.d20230403_hier_atan_epb_0, 0))
        self.connect((self.analog_const_source_x_0_0, 0), (self.d20230404_hier_atan2_epb_0, 0))
        self.connect((self.analog_const_source_x_0_1, 0), (self.d20230404_hier_atan2_epb_0, 1))
        self.connect((self.d20230403_hier_atan_epb_0, 0), (self.qtgui_number_sink_0, 0))
        self.connect((self.d20230403_hier_atan_epb_0, 1), (self.qtgui_number_sink_0_0, 0))
        self.connect((self.d20230404_hier_atan2_epb_0, 1), (self.qtgui_number_sink_0_0_0, 0))
        self.connect((self.d20230404_hier_atan2_epb_0, 0), (self.qtgui_number_sink_0_1, 0))


    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "TEST_atan_epb")
        self.settings.setValue("geometry", self.saveGeometry())
        self.stop()
        self.wait()

        event.accept()

    def get_value_y(self):
        return self.value_y

    def set_value_y(self, value_y):
        self.value_y = value_y
        Qt.QMetaObject.invokeMethod(self._value_y_line_edit, "setText", Qt.Q_ARG("QString", eng_notation.num_to_str(self.value_y)))
        self.analog_const_source_x_0_1.set_offset(self.value_y)

    def get_value_x(self):
        return self.value_x

    def set_value_x(self, value_x):
        self.value_x = value_x
        Qt.QMetaObject.invokeMethod(self._value_x_line_edit, "setText", Qt.Q_ARG("QString", eng_notation.num_to_str(self.value_x)))
        self.analog_const_source_x_0_0.set_offset(self.value_x)

    def get_value(self):
        return self.value

    def set_value(self, value):
        self.value = value
        self.analog_const_source_x_0.set_offset(self.value)

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate

    def get_pi(self):
        return self.pi

    def set_pi(self, pi):
        self.pi = pi




def main(top_block_cls=TEST_atan_epb, options=None):

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
