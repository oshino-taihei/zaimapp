init = ->
  $(document).on 'ajax:success', (e, json) ->
    container = document.getElementById("chart")
    labels = json.label
    dataset = $.map(json.data, (v, k) -> {data: v, label: k} )
    options = {
      bars: {
        show: true,
        stacked: true,
        barWidth: 0.5,
        shadowSize: 0,
        fillOpacity: 1,
        lineWidth: 0
      },
      xaxis: {
        ticks: labels
      },
      yaxis: {
        min: 0
      },
      grid: {
        verticalLines: false
      }
    }
    Flotr.draw(
        container,
        dataset,
        options
    )

$(document).ready(init)
$(document).on('page:change', init)
