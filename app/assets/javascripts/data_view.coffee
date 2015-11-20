init = ->
  $(document).on 'ajax:success', (e, json) ->
    chart_id = add_chart()
    container = $("#" + chart_id).get(0)
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

#$(document).ready(init)
$(document).on('page:change', init)


uniqueId = (length=8) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length

add_chart = ->
  chart_id = "chart_" + uniqueId()
  $("#chart").append('<div class="chart_box"><hr><div id=' + chart_id + ' class="chart"></div></div>')
  chart_id

window.delete_all_charts = ->
  $(".chart_box").remove()
  return
