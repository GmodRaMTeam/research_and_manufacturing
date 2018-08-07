<time-left>
    <!--<button show="{ !IS_IN_GAME }" class="ui button" style="position: absolute; right: -180px; bottom: 32px;" onclick="{ randomness }">-->
        <!--Random hp/armor?-->
    <!--</button>-->
    <div>
        <!--<i class="clock outline icon"></i>-->
        <h4 class="ui tiny inverted icon header">
            <!--<i class="settings icon"></i>-->
            <i class="clock icon"></i>
            <div show="{show_map}" class="content">
                {time_data[CONST_MAP]}
                <div show="{show_prep}" class="sub header">{time_data[CONST_PREP]}</div>
            </div>
        </h4>
    </div>

    <script>
        var self = this

        self.time_data = {
            map: 53.57,
            prep: 15.93,
        }

        self.show_map = true
        self.show_prep = true

        self.CONST_MAP = "map"
        self.CONST_PREP = "prep"

        /**********************************************************************
         * Init
         *********************************************************************/
        self.one('mount', function () {
            if (!IS_IN_GAME) {
                // Test mode!
                window.player = {
                    getInfo: function () {
                        return JSON.stringify({
                            health: 100,
                            armor: 100
                        })
                    }
                }
            }

            // start recurring update loop
            // console.log('before')
            update_loop()
            // console.log('after')
        })


        /**********************************************************************
         * Methods
         *********************************************************************/
        // String.prototype.toHHMMSS = function () {
        //     var sec_num = parseInt(this, 10); // don't forget the second param
        //     var hours = Math.floor(sec_num / 3600);
        //     var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
        //     var seconds = sec_num - (hours * 3600) - (minutes * 60);
        //
        //     if (hours < 10) {
        //         hours = "0" + hours;
        //     }
        //     if (minutes < 10) {
        //         minutes = "0" + minutes;
        //     }
        //     if (seconds < 10) {
        //         seconds = "0" + seconds;
        //     }
        //     return hours + ':' + minutes + ':' + seconds;
        // }

        var update_loop = function () {
            if (typeof time !== 'undefined' && typeof time.left !== 'undefined') {
                var result = time.left()
                if (result !== null && typeof result !== 'undefined') {
                    // self.time_data = JSON.parse(result)
                    // console.log(result)
                    var temp_json_result = JSON.parse(result)
                    self.time_data.map = temp_json_result.map.toString().toMMSS()
                    self.time_data.prep = temp_json_result.prep.toString().toMMSS()
                    self.update()
                    // console.log(result)
                }
            }
            window.setTimeout(update_loop, 25)
        }
    </script>
    <style scoped>
    </style>
</time-left>
