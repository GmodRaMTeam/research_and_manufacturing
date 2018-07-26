<app>
    <notifications show='{ view_notifications }'></notifications>
    <scoreboard show='{ view_scoreboard }'></scoreboard>

    <script>
        var self = this

        function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, '\\$&');
            var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, ' '));
        }

        self.on('mount', function() {
            var view = getParameterByName('view')

            self.view_scoreboard = view === 'scoreboard'
            self.view_notifications = view === 'notifications'
            self.view_hud = view === 'hud'
        })

        self.check_view = function(view_name) {
            return self.view === view_name
        }
    </script>
</app>
