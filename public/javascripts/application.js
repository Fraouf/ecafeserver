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

function model_active() {
	if($("model_active") && $("group_model_id")) {
		if($("model_active").checked) {
			$("group_model_id").disabled = false;
		} else {
			$("group_model_id").disabled = true;
		}
		$("model_active").observe("click", function() {
			if($("model_active").checked) {
				$("group_model_id").disabled = false;
			} else {
				$("group_model_id").disabled = true;
				$("group_model_id").value = 0;
			}
		})
	}
}

Event.observe(window, 'load', model_expiration_time);
Event.observe(window, 'load', model_active);