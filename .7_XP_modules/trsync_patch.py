import mcu

class TrsyncPatch:
    def __init__(self, config):
        self.printer = config.get_printer()
        enabled = config.getboolean('enabled', False)
        if enabled:
            mcu.TRSYNC_TIMEOUT = 0.050
            print("[trsync_patch] TRSYNC_TIMEOUT patched to 0.050")
        else:
            print("[trsync_patch] Plugin loaded but not active (enabled=False)")

        # Register this plugin for access
        self.printer.add_object("trsync_patch", self)

        # Create a new G-code command
        gcode = self.printer.lookup_object("gcode")
        gcode.register_command("TRSYNC_STATUS", self.cmd_trsync_status,
                                desc="Print TRSYNC_TIMEOUT value")

    def get_timeout(self):
        return "%.3f" % mcu.TRSYNC_TIMEOUT

    def cmd_trsync_status(self, gcmd):
        gcmd.respond_info(f"Current TRSYNC_TIMEOUT is {self.get_timeout()} seconds")

def load_config(config):
    return TrsyncPatch(config)
