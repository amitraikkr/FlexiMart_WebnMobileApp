$(document).ready(function() {
    getYearlySubscriptions();
    bestPlanSubscribes();
})

$('.overview-year').on('change', function () {
    let year = $(this).val();
    bestPlanSubscribes(year);
});

$('.yearly-statistics').on('change', function () {
    let year = $(this).val();
    getYearlySubscriptions(year);
});

function getYearlySubscriptions(year = new Date().getFullYear()) {
    var url = $('#yearly-subscriptions-url').val();
    $.ajax({
        type: "GET",
        url: url += '?year=' + year,
        dataType: "json",
        success: function (res) {
            var subscriptions = [];

            for (var i = 0; i <= 11; i++) {
                var monthName = getMonthNameFromIndex(i); // Implement this function to get month name

                var subscriptionsData = res.find(item => item.month === monthName);
                subscriptions[i] = subscriptionsData ? subscriptionsData.total_amount : 0;
            }
            subscriptionChart(subscriptions);
        },
    });
}

let userOverView = false;

function bestPlanSubscribes(year = new Date().getFullYear()) {
    if (userOverView) {
        userOverView.destroy();
    }

    let url = $('#get-plans-overview').val();
    $.ajax({
        url: url += '?year=' + year,
        type: 'GET',
        dataType: 'json',
        success: function (res) {

            var labels = [];
            var data = [];

            $.each(res, function(index, planData) {
                var label = planData.plan.subscriptionName + ": " + planData.plan_count;
                labels.push(label);
                data.push(planData.plan_count);
            });

            let inMonths = $("#plans-chart");
            let ctx = inMonths[0].getContext('2d');

            // Define gradient colors
            let gradient1 = ctx.createLinearGradient(0, 0, 0, 400);
            gradient1.addColorStop(0, '#32F7AC');
            gradient1.addColorStop(1, '#2CE78D');

            let gradient2 = ctx.createLinearGradient(0, 0, 0, 400);
            gradient2.addColorStop(0, '#9D87E7');
            gradient2.addColorStop(1, '#7461E7');

            let gradient3 = ctx.createLinearGradient(0, 0, 0, 400);
            gradient3.addColorStop(0, '#FBB45E');
            gradient3.addColorStop(1, '#F88222');

            let gradient4 = ctx.createLinearGradient(0, 0, 0, 400);
            gradient4.addColorStop(0, '#FFD876');
            gradient4.addColorStop(1, '#FFA500');
            userOverView = new Chart(inMonths, {
                type: 'pie',
                data: {
                    labels: labels,
                    datasets: [{
                        label: "Total Users",
                        data: data,
                        backgroundColor: [
                            gradient1,
                            gradient2,
                            gradient3,
                            gradient4,
                        ],
                        borderColor: [
                            "#2CE78D",
                            "#7461E7",
                            "#F88222",
                            "#FFA500",
                        ],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                usePointStyle: true,
                                padding: 10
                            }
                        }
                    }
                }
            });
        },
        error: function (xhr, textStatus, errorThrown) {
            console.log('Error fetching user overview data: ' + textStatus);
        }
    });
}


// PRINT TOP DATA
getDashboardData();
function getDashboardData() {
    var url = $('#get-dashboard').val();
    $.ajax({
        type: "GET",
        url: url,
        dataType: "json",
        success: function (res) {
            $('#total_businesses').text(res.total_businesses);
            $('#expired_businesses').text(res.expired_businesses);
            $('#plan_subscribes').text(res.plan_subscribes);
            $('#business_categories').text(res.business_categories);
            $('#total_plans').text(res.total_plans);
            $('#total_staffs').text(res.total_staffs);
        }
    });
}

// Function to convert month index to month name
function getMonthNameFromIndex(index) {
    var months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ];
    return months[index - 1];
}

let statiSticsValu = false;

function subscriptionChart(subscriptions) {
    if (statiSticsValu) {
        statiSticsValu.destroy();
    }

    var ctx = document.getElementById('monthly-statistics').getContext('2d');
    var gradient = ctx.createLinearGradient(0, 100, 10, 280);
    gradient.addColorStop(0, '#BEE5CC');
    gradient.addColorStop(1, 'rgba(22, 163, 74, 0)');

        var totals = subscriptions.reduce(function (accumulator, currentValue) {

        return accumulator + currentValue;
    }, 0);

    statiSticsValu = new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Jan', 'Feb', 'March', 'April', 'May', 'June', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            datasets: [{
                    backgroundColor: gradient,
                    label: "Total Subscription Amount: " + totals,
                    fill: true,
                    borderWidth: 1,
                    borderColor: "#019934",
                    data: subscriptions,
                }
            ]
        },

        options: {
            responsive: true,
            tension: 0.3,
            tooltips: {
                displayColors: true,
            },
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        usePointStyle: true,
                        padding: 30
                    }
                }
            },
            scales: {
                x: {
                    display: true,
                    grid: {
                        drawOnChartArea: false,
                    }
                },
                y: {
                    display: true,
                    beginAtZero: true,
                    grid: {
                        borderDash: [5, 5],
                    }
                }
            }

        },
    });
};
