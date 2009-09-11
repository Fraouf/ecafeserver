function model_expiration_time () {
    if($("model_expiration") && $("never")) {
        if($("model_expiration").value == "0") {
            $("never").checked = true;
            $("model_expiration").disabled = true;
        }
        $("never").observe("click", function() {
            if($("never").checked) {
                $("model_expiration").value = 0;
                $("model_expiration").disabled = true;
            } else {
                $("model_expiration").disabled = false;
            }
        });
    }
    
    if($("model_time") && $("unlimited")) {
        if($("model_time").value == "0") {
            $("unlimited").checked = true;
            $("model_time").disabled = true;
        }
        $("unlimited").observe("click", function() {
            if($("unlimited").checked) {
                $("model_time").value = 0;
                $("model_time").disabled = true;
            } else {
                $("model_time").disabled = false;
            }
        })
    }

    if($("model")) {
        $("model").observe("submit", function() {
            $("model_time").disabled = false;
            $("model_expiration").disabled = false;
            
        })
    }
}

Event.observe(window, 'load', model_expiration_time);