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
from gnuradio import eng_notation
from gnuradio import qtgui
import sip
from d20230403_hier_atan_epb import d20230403_hier_atan_epb  # grc-generated hier_block
from gnuradio import analog
from gnuradio import blocks
from gnuradio import gr
from gnuradio.filter import firdes
from gnuradio.fft import window
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx



from gnuradio import qtgui

class TEST_divide(gr.top_block, Qt.QWidget):

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

        self.settings = Qt.QSettings("GNU Radio", "TEST_divide")

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
        self.variable_qtgui_entry_1 = variable_qtgui_entry_1 = 50
        self.variable_qtgui_entry_0 = variable_qtgui_entry_0 = 50
        self.samp_rate = samp_rate = 32000

        ##################################################
        # Blocks
        ##################################################
        self._variable_qtgui_entry_1_tool_bar = Qt.QToolBar(self)
        self._variable_qtgui_entry_1_tool_bar.addWidget(Qt.QLabel("'variable_qtgui_entry_1'" + ": "))
        self._variable_qtgui_entry_1_line_edit = Qt.QLineEdit(str(self.variable_qtgui_entry_1))
        self._variable_qtgui_entry_1_tool_bar.addWidget(self._variable_qtgui_entry_1_line_edit)
        self._variable_qtgui_entry_1_line_edit.returnPressed.connect(
            lambda: self.set_variable_qtgui_entry_1(eng_notation.str_to_num(str(self._variable_qtgui_entry_1_line_edit.text()))))
        self.top_layout.addWidget(self._variable_qtgui_entry_1_tool_bar)
        self._variable_qtgui_entry_0_tool_bar = Qt.QToolBar(self)
        self._variable_qtgui_entry_0_tool_bar.addWidget(Qt.QLabel("'variable_qtgui_entry_0'" + ": "))
        self._variable_qtgui_entry_0_line_edit = Qt.QLineEdit(str(self.variable_qtgui_entry_0))
        self._variable_qtgui_entry_0_tool_bar.addWidget(self._variable_qtgui_entry_0_line_edit)
        self._variable_qtgui_entry_0_line_edit.returnPressed.connect(
            lambda: self.set_variable_qtgui_entry_0(eng_notation.str_to_num(str(self._variable_qtgui_entry_0_line_edit.text()))))
        self.top_layout.addWidget(self._variable_qtgui_entry_0_tool_bar)
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
        self.d20230403_hier_atan_epb_0_0 = d20230403_hier_atan_epb()
        self.blocks_divide_xx_0_0 = blocks.divide_ff(1)
        self.analog_const_source_x_1 = analog.sig_source_f(0, analog.GR_CONST_WAVE, 0, 0, variable_qtgui_entry_1)
        self.analog_const_source_x_0 = analog.sig_source_f(0, analog.GR_CONST_WAVE, 0, 0, variable_qtgui_entry_0)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_const_source_x_0, 0), (self.blocks_divide_xx_0_0, 0))
        self.connect((self.analog_const_source_x_1, 0), (self.blocks_divide_xx_0_0, 1))
        self.connect((self.blocks_divide_xx_0_0, 0), (self.d20230403_hier_atan_epb_0_0, 0))
        self.connect((self.d20230403_hier_atan_epb_0_0, 1), (self.qtgui_number_sink_2_0, 0))


    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "TEST_divide")
        self.settings.setValue("geometry", self.saveGeometry())
        self.stop()
        self.wait()

        event.accept()

    def get_variable_qtgui_entry_1(self):
        return self.variable_qtgui_entry_1

    def set_variable_qtgui_entry_1(self, variable_qtgui_entry_1):
        self.variable_qtgui_entry_1 = variable_qtgui_entry_1
        Qt.QMetaObject.invokeMethod(self._variable_qtgui_entry_1_line_edit, "setText", Qt.Q_ARG("QString", eng_notation.num_to_str(self.variable_qtgui_entry_1)))
        self.analog_const_source_x_1.set_offset(self.variable_qtgui_entry_1)

    def get_variable_qtgui_entry_0(self):
        return self.variable_qtgui_entry_0

    def set_variable_qtgui_entry_0(self, variable_qtgui_entry_0):
        self.variable_qtgui_entry_0 = variable_qtgui_entry_0
        Qt.QMetaObject.invokeMethod(self._variable_qtgui_entry_0_line_edit, "setText", Qt.Q_ARG("QString", eng_notation.num_to_str(self.variable_qtgui_entry_0)))
        self.analog_const_source_x_0.set_offset(self.variable_qtgui_entry_0)

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate




def main(top_block_cls=TEST_divide, options=None):

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
