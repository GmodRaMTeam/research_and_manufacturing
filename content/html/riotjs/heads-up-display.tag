<heads-up-display>
    <!--<button show="{ !IS_IN_GAME }" class="ui button" style="position: absolute; right: -180px; bottom: 32px;" onclick="{ randomness }">-->
        <!--Random hp/armor?-->
    <!--</button>-->

    <div id="container-backgrounds" class="ui inverted segment">

    </div>

    <h2 show="{player_data.ammo_data.show_crosshair}" class="ui tiny inverted icon header" id="cross-container">
        <!--<i class="settings icon"></i>-->
        <i class="crosshairs icon"></i>
    </h2>

    <div show="{player_data.ammo_data.show}" id="ammo-container" class="ui inverted segment">
        <h2 class="ui inverted header">
            <!--<i class="plug icon"></i>-->
            Ammo:
            <div class="content">
                {player_data.ammo_data.clip_cur} / {player_data.ammo_data.clip_max}
                <div show="{player_data.ammo_data.ammo_total > 0}" class="sub header">
                    Total: {player_data.ammo_data.ammo_total}
                </div>
            </div>
        </h2>
    </div>

    <div style="fill-opacity: 0.5; opacity: 0.5;" show="{show_scientist}" class="ui inverted segment" id="icon-container">
        <h2 class="ui small inverted icon header">
            <!--<i class="settings icon"></i>-->
            <i class="user secret icon"></i>
            <div class="content">
                You Have
                <div class="sub header">A Scientist</div>
            </div>
        </h2>
    </div>

    <h2 class="ui small inverted icon header" id="voting-container">
        <!--<i class="settings icon"></i>-->
        <i show="{player_data.status === 1}" class="cogs icon"></i>
        <i show="{player_data.status === 2}" class="calendar icon"></i>
        <i show="{player_data.status === 3}" class="ellipsis horizontal icon"></i>
        <i show="{player_data.status === 4}" class="exclamation icon"></i>
        <i show="{player_data.status === 5}" class="calendar check icon"></i>
        <div class="content">
            Status
            <div show="{player_data.status === 1}" class="sub header">In Progress</div>
            <div show="{player_data.status === 2}" class="sub header">Voting</div>
            <div show="{player_data.status === 3}" class="sub header">Preparing</div>
            <div show="{player_data.status === 4}" class="sub header">Map End</div>
            <div show="{player_data.status === 5}" class="sub header">Voted</div>
        </div>
    </h2>

    <h2 class="ui small inverted icon header" id="scientist-container">
        <i class="users icon"></i>
        <div class="content">
            Scientists
            <div class="sub header">{player_data.team_scientist_count}</div>
        </div>
    </h2>

    <div id="health-container">
        <div class="progress-bar-icon">
            <i class="plus alternate icon"></i>
        </div>
        <div class="ui indicating green progress" id="health">
            <div class="bar">
                <div class="progress"></div>
            </div>
            <div style="color: #21BA45;" class="label">{player_data.health}</div>
        </div>
    </div>

    <div id="armor-container">
        <div class="progress-bar-icon">
            <i class="shield alternate icon"></i>
        </div>
        <div class="ui indicating warning progress" id="armor">
            <div class="bar">
                <div class="progress"></div>
            </div>
            <div style="color: gold;" class="label">{player_data.armor}</div>
        </div>
    </div>

    <script>
        var self = this
        self.player_data = {
            health: 100,
            armor: 100,
            ammo_data: {
                show: false,
                clip_cur: 7,
                clip_max: 15,
                ammo_total: 63,
            }
        }
        self.show_scientist = false
        self.show_voting_status = true

        /**********************************************************************
         * Init
         *********************************************************************/
        self.one('mount', function () {
            // Initialize progress bars
            $('#health', '#armor').progress({
                value: 100,
                total: 100,
                autoSuccess: false,
                showActivity: false,
                label: 'percent'
            })

            if (!IS_IN_GAME) {
                // Test mode!
                window.player = {
                    getInfo: function () {
                        return JSON.stringify({
                            health: 100,
                            armor: 100,
                            has_scientist: true,
                            ammo_data: {
                                show: true,
                                clip_cur: 7,
                                clip_max: 15,
                                ammo_total: 63,
                            }
                        })
                    }
                }
            }

            // start recurring update loop
            update_loop()
        })

        self.randomness = function () {
            self.set_progress_bars({
                health: Math.random() * 100,
                armor: Math.random() * 100
            })
        }

        self.set_progress_bars = function (data) {
            // Split this out into a separate function so we could set progress bars
            // from random or from player info
            $('#health').progress(
                'update progress',
                data.health
            )
            $('#armor').progress(
                'update progress',
                data.armor
            )
        }

        /**********************************************************************
         * Methods
         *********************************************************************/
        var update_loop = function () {
            if (typeof player !== 'undefined' && typeof player.getInfo !== 'undefined') {
                var result = player.getInfo()
                if (result !== null && typeof result !== 'undefined') {
                    self.player_data = JSON.parse(result)
                    // console.log(result)
                    self.set_progress_bars(self.player_data)
                    if (self.player_data['has_scientist'] === true) {
                        self.show_scientist = true
                    } else {
                        self.show_scientist = false
                    }
                    // if (self.player_data['status'] === 2) {
                    //     self.show_voting_status = true
                    // } else {
                    //     self.show_voting_status = false
                    // }
                    self.update()
                }
            }
            window.setTimeout(update_loop, 25)
        }
    </script>
    <style scoped>
        #health-container .icon {
            position: absolute;
            top: -92px;
            left: 3px;
        }

        #health {
            position: absolute;
            left: 28px;
            bottom: 50px;
            right: 0;
        }

        #armor-container .icon {
            position: absolute;
            top: -43px;
            left: 3px;
        }

        #armor {
            position: absolute;
            left: 28px;
            bottom: 0;
            right: 0;
        }
        #armor .bar {
            background-color: gold !important;
        }

        .ui.progress {
            background: rgba(0, 0, 0, .03);
        }

        .header-text {
            color: #b1b1b1 !important;
        }

        .progress-bar-icon {
            /*display: inline-block;*/
            font-size: 20px;
            /*margin-top: 3px;*/
            color: #b1b1b1;
        }

        .bar .progress {
            /* Hide % text in progress bar */
            font-size: 0 !important;
        }

        #icon-container {
            position: fixed;
            bottom: 45%;
            left: 0px;

            /*left: 3px;*/
        }

        #voting-container {
            position: fixed;
            bottom: 0;
            left: 30%;
            /*right: 50%;*/

            /*left: 3px;*/
        }

        #scientist-container {
            position: fixed;
            bottom: -1%;
            left: 38%;
            /*right: 50%;*/

            /*left: 3px;*/
        }

        #ammo-container {
            position: fixed;
            bottom: 0;
            right: 1.5%;
            /*height: 15%;*/
            /*width: 15%;*/

            /*right: 50%;*/

            /*left: 3px;*/
        }

        #cross-container {
            position: fixed;
            bottom: 45.70%;
            right: 48.75%;
            opacity: 0.5;
            fill-opacity: 0.5;
            /*margin-top: -50px;*/
            /*margin-left: -100px;*/
            /*height: 15%;*/
            /*width: 15%;*/

            /*right: 50%;*/

            /*left: 3px;*/
        }

        #container-backgrounds {
            position: fixed;
            bottom: -2.5%;
            width: 45%;
            height: 14%;
        }

        /*https://icons8.com/icon/set/secret/all*/
    </style>
</heads-up-display>
